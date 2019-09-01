# Derived from https://github.com/nh2/nix-binary-cache-proxy
# Copyright (c) 2017 Niklas Hambüchen
# See LICENSE on this directory for copying and usage permissions

# Note: original code had cache hanging off /tmp,
# so it was deleted on restart. This version persists.
# Please ensure `/var/public-nix-cache` exists

{ config, lib, pkgs, ... }:

let
  # you include this from your /nix/configuration.nix file,
  # so your domain will be $HOSTNAME + '.local'
  domain = "${config.networking.hostName}.local";
in

{
    # Firewall all connections (except SSH which is open by default).
    networking.firewall.enable = true;
    # Reject instead of drop.
    networking.firewall.rejectPackets = true;
    networking.firewall.allowedTCPPorts = [
      80 # nginx
      443 # nginx
      5353 # avahi
    ];

    boot.kernelModules = [ "tcp_bbr" ];

    # Enable BBR congestion control
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    boot.kernel.sysctl."net.core.default_qdisc" = "fq"; # see https://news.ycombinator.com/item?id=14814530

    environment.systemPackages = [
      pkgs.htop
      pkgs.ncdu
      pkgs.nload
      pkgs.vim
    ];

    nix.binaryCaches = [
      "https://hydra.iohk.io"
      "http://cache.nixos.org/"
    ];

    nix.binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    services.nginx = {
      enable = true;
      appendHttpConfig = ''
        proxy_cache_path /var/public-nix-cache/ levels=1:2 keys_zone=cachecache:100m max_size=10g inactive=365d use_temp_path=off;

        # Cache only success status codes; in particular we don't want to cache 404s.
        # See https://serverfault.com/a/690258/128321
        map $status $cache_header {
          200     "public";
          302     "public";
          default "no-cache";
        }

        access_log logs/access.log;
      '';
      virtualHosts."${domain}" = {
        # enableACME = true;

        locations."/" = {
          root = "/var/public-nix-cache";
          extraConfig = ''
            expires max;
            add_header Cache-Control $cache_header always;

            # Ask the upstream server if a file isn't available locally
            error_page 404 = @fallback;
          '';
        };
        extraConfig = ''
          # Using a variable for the upstream endpoint to ensure that it is
          # resolved at runtime as opposed to once when the config file is loaded
          # and then cached forever (we don't want that):
          # see https://tenzer.dk/nginx-with-dynamic-upstreams/
          # This fixes errors like
          #   nginx: [emerg] host not found in upstream "upstream.example.com"
          # when the upstream host is not reachable for a short time when
          # nginx is started.
          resolver 8.8.8.8;
          set $upstream_endpoint http://cache.nixos.org;
        '';
        locations."@fallback" = {
          proxyPass = "$upstream_endpoint";
          extraConfig = ''
            proxy_cache cachecache;
            proxy_cache_valid  200 302  60m;

            expires max;
            add_header Cache-Control $cache_header always;
          '';
        };
        # We always want to copy cache.nixos.org's nix-cache-info file,
        # and ignore our own, because `nix-push` by default generates one
        # without `Priority` field, and thus that file by default has priority
        # 50 (compared to cache.nixos.org's `Priority: 40`), which will make
        # download clients prefer `cache.nixos.org` over our binary cache.
        locations."= /nix-cache-info" = {
          # Note: This is duplicated with the `@fallback` above,
          # would be nicer if we could redirect to the @fallback instead.
          proxyPass = "$upstream_endpoint";
          extraConfig = ''
            proxy_cache cachecache;
            proxy_cache_valid  200 302  60m;

            expires max;
            add_header Cache-Control $cache_header always;
          '';
        };
      };
    };
}
