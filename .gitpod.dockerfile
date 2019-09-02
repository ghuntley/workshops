FROM gitpod/workspace-full

RUN sudo apt-get update \
 && sudo curl https://nixos.org/nix/install | sh \
 && sudo rm -rf /var/lib/apt/lists/*
