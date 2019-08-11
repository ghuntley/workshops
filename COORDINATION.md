- nixos
  - 00-introduction-to-nixos
  - 01-install-nixos
      - Status: Done.
  - 02-change-nixos-configuration
      - Status: advanced, but Javier has a couple and requests for Geoff
      - TODO (JC) INCLUDE SAMPLE configuration.nix FILE
      - QUESTION(JC) Why do we have top level keys like `users` and `imports` that aren't a NixOS module? What are they?
        ```
        [kandinski@desire:~/data/work/hack/nixos/nixpkgs/nixos/modules]$ ls
        config  hardware  i18n  installer  misc  module-list.nix  profiles  programs
        rename.nix  security  services  system  tasks  testing  virtualisation
        ```
  - 03-roll-back-configuration
  - 04-introducing-the-nixstore
  - 05-introducing-channels-and-nixpkgs
  - 06-continuous-integration
  - 07-deployment
  - 08-integration-testing
  - 09-server-farms
- nix
 - 00-introduction-to-nix
 - 01-the-nix-language
     - Javier dibs this one.
 - 02-using-nix
 - 03-building-applications
   - dotnet-example
   - golang-example
   - haskell-example
   - nodejs-example
   - perl-example
   - python-example
     - Javier dibs this one.
   - ruby-example
     - Status: Done, at least for Melbourne::Compose 2019 run of the workshop
   - rust-example
   - scala-example
 - 04-publishing-applications
 - 05-building-docker-containers
 - 06-cross-compilation
 - 07-hermetic-incremental-builds-with-bazel
