- nixos
  - 00-introduction-to-nixos
  - 01-install-nixos
      - Status: Done.
  - 02-change-nixos-configuration
      - Status: advanced, but Javier has a couple and requests for Geoff
      - TODO (JC) INCLUDE SAMPLE configuration.nix FILE
      - QUESTION(JC) Why do we have top level keys like `users` that aren't a NixOS module? What are they?
        ```
        [kandinski@desire:~/data/work/hack/nixos/nixpkgs/nixos/modules]$ ls
        config  hardware  i18n  installer  misc  module-list.nix  profiles  programs
        rename.nix  security  services  system  tasks  testing  virtualisation
        ```
  - 03-roll-back-configuration
    - Geoff dibs this one.
  - 04-introducing-the-nixstore
    - Geoff dibs this one
  - 05-introducing-channels-and-nixpkgs
    - Geoff dibs this one
    - Javier's special request: Overlays, Overrides, and what Debian calls "pinning" or "backporting"
  - 06-continuous-integration
    - Geoff dibs this one
  - 07-deployment
  - 08-integration-testing
  - 09-server-farms

- nix
  - 00-introduction-to-nix
      - Javier dibs this one
  - 01-the-nix-language
      - The wiki is great for the explainer.
      - Javier dibs this one.
  - 02-using-nix
      - Question: do you mean using nix the package manager? As if you install Nix on Ubuntu/MacOS?
  - 03-building-applications
    - dotnet-example
    - golang-example
      - Geoff dibs this one
    - haskell-example
      - Geoff dibs this one
    - nodejs-example
    - perl-example
    - python-example
      - Javier dibs this one.
      - "FFI dependencies"
    - ruby-example
      - Status: Done, at least for Melbourne::Compose 2019 run of the workshop
    - rust-example
    - scala-example
  - 04-publishing-applications
    - NixOS CI module (nix-copy-closure, which is fundamentals of NixOS, so there'll be some crossover)
  - 05-building-docker-containers
    - Geoff dibs this one.
  - 06-cross-compilation
  - 07-hermetic-incremental-builds-with-bazel
