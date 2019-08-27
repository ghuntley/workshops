# Introduction to Nix

## 📖 Overview

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

## ✋ Before You Begin

You need to have the Nix package manager installed on your computer. Per-platform installation instructions can be found in the [previous module][previous-module].

## 💡 What is Nix

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

Efforts are being made to make Nix and NixOS work natively under WSL. For now,
you have two options:

- you can download a preinstalled [Ubuntu 18.04 VirtualBox image] server on it,
and try the Nix tutorial there.
- you can install Nix as a single-user package manager on top of WSL-hosted
  Ubuntu 18.04 or later. WSL2 is recommended for better performance.

## 📚 Additional reading material

* [Introducing Nix]
* [Getting started with Nix]
* [Nix Manual Glossary]

## ⏭️ What's next

In [the next module][next-module] you'll learn about using Nix as a package manager. First
we'll recap some of the tasks you've already performed, then we'll dive into
more tasks.

<!-- in-line links -->
[About Nix]: http://nixos.org/nix/manual/#ch-about-nix
[Introducing Nix]: http://qfpl.io/posts/nix/introducing-nix/
[Getting started with Nix]: http://qfpl.io/posts/nix/getting-started-with-nix/
[Nix Manual Glossary]: https://nixos.org/nix/manual/#part-glossary

[previous-module]: ../00-prerequisites/README.md
[next-module]: ../01-using-nix/README.md
