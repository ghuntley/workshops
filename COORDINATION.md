- nixos
  - 00-prerequisites
      - Status: Done.
  - 01-introduction-to-nixos
      - Status: Done.
  - 02-install-nixos
      - Status: Done.
  - 03-change-nixos-configuration
      - Status: Done (Javier has questions and requests)

      - QUESTION(JC) Why do we have top level keys like `users` that aren't a NixOS module? What are they?
        ```
        [kandinski@desire:~/data/work/hack/nixos/nixpkgs/nixos/modules]$ ls
        config  hardware  i18n  installer  misc  module-list.nix  profiles  programs
        rename.nix  security  services  system  tasks  testing  virtualisation
        ```
  - 04-roll-back-configuration
      - Status: Done.
  - 05-introducing-the-nixstore
    - Geoff dibs this one
  - 06-introducing-channels-and-nixpkgs
    - Geoff dibs this one
    - Javier's special request: Overlays, Overrides, and what Debian calls "pinning" or "backporting"
  - 07-continuous-integration
    - Geoff dibs this one
  - 08-deployment
  - 09-integration-testing
  - 10-server-farms

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
