# 🗹 Overview

# ✋ Before You Begin


# 💡 Introduction to NixOS

Ideas that change the way we do computing come rarely. A lot of the technology that we are using now are just re-hashes of old ones—layers upon layers of cosmetics enveloping old concepts. Entire product lines are based upon this lack of creativity and ingenuity. Old problems are not solved. Instead, these so-called innovative solutions merely pass around the problem while painting it with new shades, claiming that at least, they made it more colorful. This mentality harms progress in innumerable ways. This gives the false impression that solutions are actually being done. This creates a false sense of assurance of improvements.

How many times have you had a broken system because you upgraded a software that other components depended on? How many late night stays have you had because you had to make an application work, because the new package that you installed broke it? How many times, when in frustration, you gave up repairing your system and just decided to re-install your system from scratch? Restoring data files are easy; restoring system configuration from the last working state, however, is a one-way ticket to hell.

NixOS is a Linux distribution that solves these problems by leveraging on the determinism of Nix and by using a single declarative configuration file that contains all settings and knobs in one place — `/etc/nixos/configuration.nix`. This file contains information about your filesystems, users, services, network configuration, input devices, kernel parameters, and more. This means that you can take a configuration.nix of someone, and have his exact system configuration! In NixOS you don’t have to fiddle around with the whole system manually for configuration that you want. You don’t have to use ad-hoc solutions to specify a desired configuration state. You don’t need to install additional software to manage system configuration.

NixOS does not follow the [FHS](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard). This gives room for a lot of flexibility and ingenuity. It does not have `/usr/` and `/opt/`. It does have `/bin/` and `/usr/bin/`, which contains only `sh` and `env`, respectively — both of which are actually symlinks to the real programs somewhere in `/nix/store/`. The top-level location for system binaries — the ones installed explicitly by the administrator—are located in `/run/current-system/sw/bin/` and `/run/current-system/sw/sbin/`. User-installed programs, on the other hand, are available at their respective `~/.nix-profile/bin/`. These locations cannot be modified through normal means; dedicated programs must be used to write to these trees.

# ⏭️ What's next

# 🙌 References and Acknowledgements
- [A Gentle Introduction to the Nix Family](https://ebzzry.io/en/nix)
