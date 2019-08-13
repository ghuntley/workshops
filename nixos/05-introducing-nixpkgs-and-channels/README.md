# Overview


There are two ways to install packages with Nixpkgs: the [git checkout](https://github.com/nixos/nixpkgs), which is the bleeding edge, up-to-the-minute updated version, or by using channels. The git repository is ideal for people who want to use the latest and greatest available version of a package, or for those who want to test things out. [Channels](https://nixos.org/channels/) on the other hand, are essentially snapshots of the git repository at an earlier version.

## Introducing nixpkgs

## Introducing channels

Installing packages via channels is nicer, because the commands to install packages with it are more convenient. The trade-off is that the packages will be out-of-date by a few days. If you’re fine with it, then use channels instead of the git checkout.

Channels are labeled `stable`, `unstable`, or with a specific version number, e.g., `18.09` or `19.03`. 

For this article, let’s use the unstable channel—it’s not as dated as stable, nor as recent as the git checkout. To subscribe to the unstable channel, run:

```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
```

This fetches the channel labeled nixpkgs-unstable from nixos.org, then installs it to your user profile.

To browse the list of channels, go [here](https://nixos.org/channels/).

Using the example above, to install emem, run the following commands for NixOS and other systems, respectively:

```bash
nix-env -iA nixos.emem
nix-env -iA nixpkgs.emem
```

To update your channels, run:

```bash
nix-channel --update
```

# Activities

1. Clone nixpkgs, install a package from it.
1. Visit list of available channels website
1. Show configured channel, add unstable channel, `nix-channel --update`, install package from unstable.
1. To uninstall a package via $ nix-env -e emem
1. To list all your installed packages, $ nix-env -q --installed
1. To list all available packages, $ nix-env -q --available

# What's Next
