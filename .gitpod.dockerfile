FROM gitpod/workspace-full

USER gitpod 

RUN sudo apt-get update \
 && sudo curl https://nixos.org/nix/install | sh \
 && sudo rm -rf /var/lib/apt/lists/*
