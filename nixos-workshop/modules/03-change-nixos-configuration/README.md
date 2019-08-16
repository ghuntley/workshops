# Change NixOS Configuration

## 📖 Overview

As described in the introduction, NixOS is a GNU/Linux distribution with a
declarative system configuration manager. The whole operating system is built by
the Nix package manager from a description in a purely functional language, also
called Nix. For the purpose of this section, we'll consider the Nix language as a black box,
and we'll treat `configuration.nix` as a configuration file with a slightly
alien syntax.

For those at the Melbourne :: C◦mp◦se 2019 workshop:

* We've already changed the configuration in our NixOS system to ensure we can use mdns and to set up a local proxy-cache to download packages from. We did it in two steps: we edited the `configuration.nix` file and we ran the `nixos-rebuild` command.

By the end of this module you will have:

* Saved your progress so far using the DevOps principal of "Infrastructure as Code".
* Further customized your operating system configuration.
* Tested your operating system configuration.
* Applied your operating system configuration.
* Commited ("switched") your operating system configuration.
* Learned about generations and discovered how to rollback to a last good via GRUB.

## 🎯 Infrastructure as Code

Let's save your progress so far!

Run `nix-env -iA nixos.git` to make git available. This command does not globally install git, instead git is installed into `~/.nix-profile/bin/` of the root user. Here you are reaping the rewards of NixOS not following the [Filesystem Hierarchy Standard][fhs-standard]. On other GNU/Linux distributions git would have been installed globally and that would be the system wide version for all users. 

With NixOS, you can side-by-side multiple versions of the same software for any user without stomping on other users. You get one of the benefits of docker, but without overhead, complexity and instability.

Let's initialize a git repository and create a checkpoint:

```bash
cd /etc/nixos
git init
git add -A
git commit -m "initial commit"
```

## 🎯 Customising NixOS

Let's further customise NixOS:

```bash
# Or, you know, use `nano` or whatever else you might prefer.
vi /etc/nixos/configuration.nix
```

Enable X11 with KDE5 and network manager:

```nix
networking.networkmanager.enable = true;
services.xserver.displayManager.sddm.enable = true;
services.xserver.desktopManager.plasma5.enable = true;
```

In addition to these core configuration items, you might want to install some packages to get you started. Your NixOS install is currently really bare. You can search for packages to install with `nix-env -qaP | grep $PACKAGE`. Add any additional packages that catch your fancy.

Add the following packages at minimum to your configuration:

```nix
environment.systemPackages = (with pkgs; [
  firefox
  git
  htop
  networkmanagerapplet
  nix-prefetch-scripts
  nix-repl
  vim
  wget
  which
  tmux
]);
```


Finally, it’s not a good idea to use root all the time, so let's create a `workshop` user with a home directory and add the user to a few groups. Most importantly, let's add the user to be a member of `wheel` so that the account can run privileged commands (`nixos-rebuild` and `reboot`) with sudo.

```nix
users.extraUsers.workshop = {
  createHome = true;
  extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
  group = "users";
  home = "/home/workshop";
  isNormalUser = true;
  uid = 1000;
};
```

Now set a password for the workshop account via `passwd workshop`.

## 🎯 Reboot NixOS and interrupt booting when at the GRUB menu

Notice you are at generation 1.
Notice that no changes have been applied.

## 🎯 Test the operating system configuration

"fix up any compilation errors as need be"

"save your progress in git"

## 🎯 Apply the operating system configuration

"apply is not commit". pull out power cable to save the day!

## 🎯 Reboot NixOS

It's gone?!

## 🎯 Apply the operating system configuration

It's permanent but undoable

## 🎯 Reboot NixOS and interrupt booting when at the GRUB menu

Select Generation 1.
"you are at a console"

## 🎯 Reboot NixOS and interrupt booting when at the GRUB menu

Select Generation 2.
"you are at x11"

## 🎯 Save your progress

"git commit"

## 💡 Structure of /etc/nixos/configuration.nix

A `configuration.nix` file is really a function definition in the Nix language.
It usually starts with `{config, pkgs, ... }:` which means it takes two
arguments: config and pkgs. Then it returns a set of option definitions
(key/value pairs of the form `{ option = definition; }`) that, processed by
nixos-rebuild, updates the system. We'll explain later how this works.


We've included a sample file in the repo that we recommend you look
at as you go through this description. 

@@TODO (JC) INCLUDE SAMPLE configuration.nix FILE

  - `boot`: Most systems will use Grub 2, which can be configured to boot with
    BIOS or UEFI.
  - `fileSystems`: Defines and mounts filesystems, but changing this
    configuration will only affect mount options, not formatting. That is: if
    you have a `vfat` filesystem and change the `fsType` option to `ext4`, the
    mount will stop working, but your data won't be compromised by a
    reformatting.
  - `imports`: Nix files are modular, and `configuration.nix` is no exception.
    The default `configuration.nix` generated by a clean install with
    `nixos-install` will generate a second `hardware-configuration.nix` that
    gets imported at the head of the file. Another example: the server running
    the nixpkgs cache-proxy for this workshop is configured by including a .nix
    file into its `configuration.nix`:
      ```
        imports =
         [ # Include the results of the hardware scan.
           ./hardware-configuration.nix
           # Binary cache proxy for the NixOS tutorial at Compose 2019
           ./nix-binary-cache-proxy.nix
         ];
       ```
  - `nix`: Configuration for the Nix package manager itself. you can add new
    binary caches for built packages, or public keys for the new binary caches.
    For instance, if you want to save yourself compiling the `leksah` editor for
    Haskell, you can use the public binaries compiled by IOHK:
      ```
        nix.binaryCaches = [ 
          "https://hydra.iohk.io"
          "http://cache.nixos.org/"
        ];

        nix.binaryCachePublicKeys = [
          "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      ```
  - `hardware`: What it says on the tin. Mostly binary blobs and proprietary
    drivers.
  - `nixpkgs`: Configuration about which package sets you want discoverable on
    your system. The following configuration options speak for themselves, so
    the comments explain why one might want to use them:
      ```
        nixpkgs.config = {
          # Mostly because of the need for MicroSoft fonts and Steam:
          allowUnfree = true;
          # because EVDI/displaylink was broken on the update to 19.03 Koi
          # but not broken enough that it was completely useless:
          allowBroken = true;
        };
      ```
    The `nixpkgs.overlay` attribute can also be used to extend and change the
    set of available packages. It's NixOS's equivalent to Debian package
    pinning.
  - `time`: Configure your system's timezone.
      ```
        time.timeZone = "Australia/Melbourne";
      ```
  - `i18n`: Configure your system's font, keymap, locale...
      ```
        i18n = {
          consoleFont = "Fira Mono";
          consoleKeyMap = "us";
          defaultLocale = "en_AU.UTF-8";
        };
      ```
  - `networking`: Set your system's hostname, enable a firewall and define open
    ports.
  - `environment`: This defines the default profile's environment. Among other
    things, this means that here we can configure the applications that will be
    available to the root profile and to users' profiles by default.
  - `services`: NixOS has a number of systemd-configured services it can run.
    From openssh to nginx, from avahi/mdns to printing... even the X11 windowing
    system is defined as a NixOS/systemd service.
  - `Virtualisation`: virtualbox, xen, libvirt and docker are among the
    pre-defined virtualsation services that NixOS offers. Note that these aren't
    installed as applications! Let's enable all of them at the same time:
      ```
        virtualisation.virtualbox.host.enable = true;
        nixpkgs.config.virtualbox.host.enableExtensionPack = true;
        
        virtualisation.libvirtd.enable = true;
        
        virtualisation.docker.enable = true;
      ```
    Note that, for users to be able to use virtualisation, they need to be added
    to the corresponding unix groups (see below).
  - `users`: User and group creation is also managed as part of NixOS: removing
    a user and running `nixos-rebuild` will not delete their `/home/username`
    directory, but will delete them from the generated `/etc` files in the
    current profile as if they'd never existed.
      ```
        users.extraUsers.nedkelly = {
          isNormalUser = true;
          description = "Ned Kelly";
          extraGroups = [
            "adbusers"
            "audio" "disk" "docker" "networkmanager" "plugdev"
            "systemd-journal" "wheel" "vboxusers" "libvirtd" "video"
          ];
          uid = 1000;
        };

        users.defaultUserShell = "/run/current-system/sw/bin/bash";
      ```
    Please remember to give your new user a password with `passwd`.

## 💡 nixos-rebuild

The nixos-rebuild command takes a NixOS system in a working state and a
`configuration.nix` file, and returns a changed working state according to the
configuration file. Here are the most common subcommands:

  - `nixos-rebuild switch`: Build the new system configuration, activate it and
    add it to GRUB as the new default boot option.
  - `nixos-rebuild boot`: Build the new system configuration and add it to GRUB
    as the new default boot option, but don't activate it. The system continues
    running the previous configuration.
  - `nixos-rebuild test`: Build the new system configuration and activate it,
    but don't add it to GRUB as the new default boot option, but don't activate
    it. If you need to reboot, the new configuration won't be available on the
    boot menu.
  - `nixos-rebuild build`: Build the new system configuration, but don't
    activate it nor add it to the GRUB boot menu.

Other subcommands are useful for debugging by performing dry runs or building
qemu virtual machines. Check `man nixos-rebuild` if you want to learn more.

The `nixos-rebuild` command also has options. Here are the most common:

  - `--upgrade`: fetches the latest version of NixOS from the NixOS channel
    before rebuilding.
  - `--install-bootloader`: use to reinstall the bootloader after changing the
    device configuration.
  - `--no-build-nix`: usually, nixos-rebuild first builds the latest version of
    the Nix package manager before rebuilding. This option disables this.
  - `--fast`: equivalent to `--no-build-nix --show-trace`. Use when you're
    calling `nixos-rebuild` frequently.
  - `--rollback`: Don't build a new configuration based on
    /etc/nixos/configuration.nix. Rather, roll back the previous configuration.
  
More options allow you to declare remote builders, change profiles (GRUB
submenus) to install your new configuration at, and even target a different host
to activate the new configuration on. As always, check `man nixos-rebuild`.


## ⏭️ What's next

<!-- in-line links -->
[fhs-standard]: https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
