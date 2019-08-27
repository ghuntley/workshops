# Introduction to Nix

##    Overview

This workshop provides a view of Nix, the purely functional package manager, and
the Nix expression language, which is used to define packages for Nix.

> 🛈 For the rest of this tutorial we'll use "Nixlang" interchangeably with the
> longer phrase 'Nix expression language' whenever we feel the need to prevent
> potential confusion.

Nix can be used as a package manager on non-NixOS GNU/Linux distributions as
well as on MacOS, so this section of the tutorial is useful even if you don't
plan to run NixOS full time. If you' re using a GNU/Linux distro, Nix can be
used to install new software (or new versions** alongside system-installed
packages. If you're on MacOS, Nix can be a replacement/supplement for MacPorts
or Homebrew.

By the end of this module you will:

* Learn what the Nix package manager is, and how it improves on existing
* Learn how to install the Nix package manager on your GNU/Linux or MacOS
  computer.
* Learn how to use basic Nix commands to install and manage packages.


## What is Nix

Nix is a purely functional package manager.

Every package has a hash based on everything that was used to build it, and the
package outputs are placed in an immutable store that is keyed on that hash.

The [About Nix] chapter of the Nix manual provides a more detailed overview of the
benefits of Nix. In summary, we get these benefits:

* we have atomic upgrades and rollbacks
* we can have multiple versions of packages installed
* multiple non-privileged users installing packages without issue
* we have a simple functional language that can be used to describe these
  packages
* our package descriptions always have a complete description of their
  dependencies
* we can share a cache of build artifacts and know that we’re getting the same
  outputs as if we’d built everything from the source code ourselves

That idea can be extended to managing a whole Linux distribution (NixOS) a fleet
of machines (NixOps), but here we're looking at the package manager.

## 🎯 Installing Nix

If you're on NixOS, you won't need to install it. The whole distribution is
built around the Nix package manager.

### If you're on MacOS or a non-NixOS distribution

For the trusting, a quick way to do install Nix for a single user is:

```bash
> sudo mkdir /nix
> sudo chown myuser /nix
> curl https://nixos.org/nix/install | sh
```

It will set Nix up in `/nix` and add this line to the end of `~/.profile `

```bash
if [ -e /home/username/.nix-profile/etc/profile.d/nix.sh ]; \
then . /home/username/.nix-profile/etc/profile.d/nix.sh; fi
```

That line will add `~/.nix-profile/bin` and `~/.nix-profile/sbin` to your path,
and will export `NIX_PATH` and a few other environment variables. The purpose of
those changes will become during this tutorial, but for now we can either source
that file or login again in order to pick up on those changes.

You can uninstall Nix at any time with:

```bash
rm -Rf /nix
```

and deleting that extra line from `~/.profile`

### If you're on Windows

Efforts are being made to make Nix and NixOS work under WSL. For now, you can
download a preinstalled [Ubuntu 18.04 VirtualBox image] server on it, and try
these parts of the tutorial.

NOTE TO GHUNTLEY: Right now I advise to just install Ubuntu on VBox, because
I've never been able to get Nix to work on WSL. Happy for you to correct this, 
since you know how and when it does and doesn't work.

# What's Next

# References and Acknowledgments
- [Introducing Nix]
- [Getting started with Nix]
- [Nix Manual Glossary]

<!-- in-line links -->
[About Nix]: http://nixos.org/nix/manual/#ch-about-nix
[Introducing Nix]: http://qfpl.io/posts/nix/introducing-nix/
[Getting started with Nix]: http://qfpl.io/posts/nix/getting-started-with-nix/
[Nix Manual Glossary]: https://nixos.org/nix/manual/#part-glossary
[Ubuntu 18.04 VirtualBox image]: https://sourceforge.net/projects/osboxes/files/v/vb/59-U-u-svr/18.04/18.04.3/S18.04.3VB-64bit.7z/download

