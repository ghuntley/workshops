# Overview

Install NixOS

## ✋ Before You Begin

### Full install onto real hardware or a VirtualBox VM

If you want to install NixOS on your laptop we not only invite you to it: we'll
be glad to help.

Here are two great howtos on installing NixOS:

https://qfpl.io/posts/installing-nixos/

This one manages to encrypt all fileystems: not just the usual root and swap,
but also boot:

https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f


## Import a prebuilt appliance into a VirtualBox VM

The NixOS project helpfully provides for download what it calls "appliances",
donwloadable images you can import into VirtualBox.

This is what we will be doing in our workshop. We assume you've already
installed VirtualBox and the host extensions.

Please pay attention to the instructions, because otherwise your VM might not
work properly:

1. Download
   https://releases.nixos.org/nixos/19.03/nixos-19.03.173251.56d94c8c69f/nixos-19.03.173251.56d94c8c69f-x86_64-linux.ova
1. Import it into VirtualBox using the menu option `File -> Import Appliance`
1. Before running the appliance, go into the settings and change the following
   details:
  1. System/Motherboard: Raise memory to 4GB, or some rebuild operations might
     fail.
  1. Network/Adapter2: Ensure you have your host laptop's wifi card as `Attached
     to: Bridged Adapter`
  1. USB: Disable USB 2.0 and enable 1.1 instead. Some VirtualBox installations
     won't have the host extensions.
1. Run the appliance by right-clicking on it, then selecting `Start ->
   Detachable Start`
1. Open a terminal and gain root access with the password `demo`.

## Some housekeeping for the Melbourne :: Compose 2019 Workshop

Let's add a couple of extra touches to make the rest of the workshop easier.
This will also serve as your introduction to the way NixOS does things.

We have prepared a local package proxy-cache for this workshop, so we're not
bottle necked by external network access. We'll have to configure that in your
VMs. We've also configured the proxy-cache server to use the mdns name
`dymaxion.local`, so you'll have to configure your VMs to use avahi/mdns.

A NixOS sytem is defined by a configuration file located at
`/etc/nixos/configuration.nix`. In the VirtualBox appliance, it's write
protected. In the root terminal you opened in the previous point, make it
writable:

```bash
chmod 644 /etc/nixos/configuration.nix
```

Now you can edit the file (both nano and vim are available) and add the

following lines:

```nix
# avahi/mdns/bonjour/rendezvous
services.avahi.enable = true;
services.avahi.nssmdns = true;

nix.binaryCaches = [
    "http://dymaxion.local"
    "https://cache.nixos.org"
];
```

Exit your editor and, still as root, run the following command:

```bash
nixos-rebuild switch
```

Now your VM should be able to use avahi (check by running `ping dymaxion.local`
and the first source for binary packages will be the workshop proxy-cache).
We'll see how all of this works in the next section.

## Now type this

- Install git with `nix-env -iA nixos.git`. This is not the preferred way to install software on NixOS, but it's a quick and easy fix, and good to know
so you can keep working.
- Initialise a git repo on `/etc/nixos` with `# cd /etc/nixos && git init &&
git add . && git commit -m "Initial comit"`. Now you can track your changes
to your NixOS configuration.
- Notice that git is available to the root user, but not to your demo user.
This is because they are different environments, and by using `nix-env` you
only installed on root's user profile, not on the system.
- Reboot your VirtualBox appliance and, on the Grub screen, select the `NixOS
-- All Configurations` menu and, after that, select `Configuration 1`.
You'll reboot in a NixOS system without avahi and the local binary caches
we've set up for this workshop. Test that this is true by running `ping
dymaxion.local`.
- Now check that booting an earlier generation of your system didn't change
the filesystem. Type `head /etc/nixos/configuration.nix` and you'll see the
avahi and binaryChanges edits you made are still there.
- We do want your system to use the local cache, so please rebuild your
running system with `sudo nixos-rebuild --test`. This will leave your system
as if you'd booted with the avahi/local cacheproxy configuration, but
without adding a new configuration to your type menu.
  

## Maybe type this later

  - You can always declare your `binaryCaches` on the command line, where the
    option is called `substituters`. During the workshop, maybe try
    `nixos-rebuild --option substituter https://cache.nixos.org/ test` and
    `nixos-rebuild --option substituter $LOCAL_CACHE_PROXY_IP test`. It may look
    like it's doing nothing now if the rebuild operation doesn't require network
    access, but it can be a lifesaver if you stuff up your `binareCaches`
    configuration. 
  - For instance, you may need to run `nixos-rebuild --option substituter
    https://cache.nixos.org/ switch` in when you move away from our
    `dymaxion.local` proxy after you leave the workshop.


## What's next
