# Using Nix

## Overview

This section will provide a run-through of how to perform common task using the
suite of programs collectively known as the "Nix package manager", as well as some
third-party utilities.

If you have done the NixOS workshop, you will have already used some of these
programs, like `nix-env` and `nix-channel`, to perform truly essential tasks.
We'll put these tasks at the beginning, in a "recap" section.

Then we'll focus on several activities, and how to perform them, rather than
focus on the tools themselves. The executables come with very good manpages and
`--help` sections, and the [Nix Manual] contains a more detailed reference.

This module doesn't contain any NixOS-specific commands, and can be worked
through on a regular user account, either on NixOS or on any other Nix-enabled
OS.

## 🗹 Recap

We've already been using the Nix package manager during the NixOS tutorial. If
you started at the Nix tutorial, this is your chance to catch up:

* We installed software with `nix-env -iA nixos.$PACKAGE`
* We searched packages with `nix-env -qaP | grep $PACKAGE`
* We listed generations of the current profile with `nix-env --list-generations`
* We cleared up unused builds from the `/nix/store` with `nix-collect-garbage`
* We queried available package channels with `nix-channel --list`
* We added a channel with `nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs`
* We updated the channel package list with `nix-channel --update` or `nix-channel -u`
* We rolled-back the channel state with `nix-channel --roll-back`

## Installing Software

* Notes: -i and -q use a "package selector" which is a regex that will match a
  symbolic package name. More than one package can share a symbolic package
  name.
* Why we use the -A toggle, and what's -f Maybe don't delve into `./nix-defexpr`
  now, wait until we look at nixpkgs/channels again
* What happens when we don't use the -A toggle.
* TODO What to install in the OS, what to install in the user, what to install in nix-shells.
* TODO Installing Python programs versus libraries (JC: TODO)

## Removing Software

* Removing a package with --remove (-r): easy peasy.
* We still haven't seen garbage removal. Coming soon!

## Searching

* `nix-env -q` vs `nix-env -qa` vs `nix-env -qaP`
* Nix 2 on the horizon: `nix search`


## Task 3

* TODO


## 📚 Additional reading material


<!-- in-line links -->
[Nix Manual]: https://nixos.org/nix/manual/