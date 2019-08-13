# Overview

Most of the popular operating systems handle packages well, until, they don’t. As long as you are moving in a straight line, alone, you’ll be fine. Things change, when you introduce other people in the walk. For the whole cast to move in unison, everyone must be strictly connected to one another. If a member decides to break off, and walk on his own, the entire cast becomes crippled. However, if that member clones himself so that the departing copy becomes independent, the original walking cast becomes undisturbed.

Let’s take the case of a distribution aimed as a multi-user production development environment. When you install Firefox version 100, the main binary goes to either `/usr/bin/firefox` or `/usr/local/bin/firefox`. All the users then, in this system, will be able to access the application from that path; John, Mary, and Peter are happy. However, when John upgrades it to version 200, the same application that is being used by Mary and Peter get upgraded, too! That’s not a good thing if they prefer the old version that works with them! Nixpkgs allows you have multiple versions of a software, without collisions from the other versions. John, Mary, and Peter can all have their versions of Firefox without conflicting with the other versions. How does Nixpkgs do it? It does it by naming components by their computed checksums, and by not using a common global location.

Each user has their own versions of `~/.nix-profile` and all of the contents of those directories do not contain regular files. Instead, they are all symbolic files to the actual files located in `/nix/store/`. This directory is where programs and their dependencies are actually installed. The only way to write to that directory is through the Nix-specific programs. There is no way to modify the contents of that directory through normal means. So, when regular user john installs Vim 8, the program becomes installed as something like `/nix/store/w4cr4j13lqzry2b8830819vdz3sdypfa-vim-8.0.0329`. The characters before the package name is the checksum of all the inputs to build the package. The file `/home/john/.nix-profile/bin/vim` then points to a symlink to a file in `/nix/store/` that will lead to the actual Vim binary in `/nix/store/w4cr4j13lqzry2b8830819vdz3sdypfa-vim-8.0.0329/bin/vim`.


## Activites

1. Enable automatic garbage collection in /etc/nixos/configuration.nix
2. Activate the configuration
3. Manually run nix-collect-garbage

## Notes

Over time, trees in /nix/store/ accumulate and there may be paths that are no longer referenced by any package. To clean it up, run:

$ nix-collect-garbage


# What's Next

# References and Acknowledgements
- [A Gentle Introduction to the Nix Family](https://ebzzry.io/en/nix)
