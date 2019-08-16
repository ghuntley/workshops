# Introduction to NixOS

![NixOS logo](nixos-logo.png)

## 📖 Overview

This workshop provides a walk through of installing, configuring and administrating NixOS. Each module contains some background information on major features and concepts in NixOS, and includes activities to apply what you have learned.

By the end of this module you will:

* Learn what NixOS is and understand how NixOS has solved fundamental problems which plague other operating systems.
* Discover that NixOS does not use the standard directory structure found in other Linux distributions.
* Discover that configuration management tools are not required.
* Discover that `sudo` is no longer required.

## 💡 What is NixOS

How many times have you had a broken operating system because you upgraded a software that other components depended on? How many late night stays have you had because you had to make an application work, because the new package that you installed broke it? How many times, when in frustration, you gave up repairing your operating system and just decided to re-install your operating system from scratch? Restoring data files are easy; restoring system configuration from the last working state, however, is a one-way ticket to hell.

Ideas that change the way we do computing come rarely. A lot of the technology that we are using now are just re-hashes of old ones, layers upon layers of cosmetics enveloping old concepts. Entire product lines are based upon this lack of creativity and ingenuity. Old problems are not solved. Instead, these so-called innovative solutions merely pass around the problem while painting it with new shades, claiming that at least, they made it more colorful.

NixOS is a Linux distribution that solves these problems by leveraging on the determinism of [Nix][nix-workshop] and by using a single declarative configuration file that contains all settings and knobs in one place — `/etc/nixos/configuration.nix`. This file contains information about your file-systems, users, services, network configuration, input devices, kernel parameters, and more. This means that you can take a configuration.nix of someone, and have his exact system configuration! In NixOS you don’t have to fiddle around with the whole system manually for configuration that you want. You don’t have to use ad-hoc solutions to specify a desired configuration state. You don’t need to install additional software to manage system configuration.

NixOS does not follow the [FHS][fhs-standard]. This gives room for a lot of flexibility and ingenuity. It does not have `/usr/` and `/opt/`. It does have `/bin/` and `/usr/bin/`, which contains only `sh` and `env`, respectively — both of which are actually symlinks to the real programs somewhere in `/nix/store/`. The top-level location for system binaries — the ones installed explicitly by the administrator—are located in `/run/current-system/sw/bin/` and `/run/current-system/sw/sbin/`. User-installed programs, on the other hand, are available at their respective `~/.nix-profile/bin/`. These locations cannot be modified through normal means; dedicated programs must be used to write to these trees.

## 🗹 Recap

1. You don’t need to install additional software to manage system configuration. Desired state configuration is built into the operating system, removing the need for configuration management tools such as Chef, Puppet or Ansible.
1. Configuration of the operating system is defined in a single declarative configuration file at  `/etc/nixos/configuration.nix`
1. NixOS does not follow the [FHS][fhs-standard] standard and `/usr/` or `/opt` does not exist. Instead symbolic links to directories under `/nix/store/` are heavily used. More information about how this works is provided in a future module.
1. Sudo is not needed. Users can install any program without needing sudo privledges. Programs are installed into the users home direcotry at `~/.nix-profile/bin/`.

## ⏭️ What's next

In [the next module][next-module] you'll install NixOS either on computer as it's primary operating system or in a virtual machine on your computer. Each module from here onwards you'll learn about NixOS concepts and how to manage NixOS.

<!-- in-line links -->
[nix-workshop]: ../../nix-workshop/README.md
[fhs-standard]: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
[next-module]: (../01-install-nixos/README.md)
