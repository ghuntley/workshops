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

* Learn what the Nix package manager is, and how it improves the status quo

## ✋ Before You Begin

You need to have the Nix package manager installed on your computer before proceeding. Per-platform installation instructions can be found in the [previous module][previous-module].

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
