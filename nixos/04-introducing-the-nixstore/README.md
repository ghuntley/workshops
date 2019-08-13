# Overview


## Activites

1. Enable automatic garbage collection in /etc/nixos/configuration.nix
2. Activate the configuration
3. Manually run nix-collect-garbage

## Notes

Over time, trees in /nix/store/ accumulate and there may be paths that are no longer referenced by any package. To clean it up, run:

$ nix-collect-garbage


# What's Next
