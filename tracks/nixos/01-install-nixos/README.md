# Install NixOS


## Full install onto real hardware or a VirtualBox VM

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

1. Download https://releases.nixos.org/nixos/19.03/nixos-19.03.173251.56d94c8c69f/nixos-19.03.173251.56d94c8c69f-x86_64-linux.ova
1. Import it into VirtualBox using the menu option ""File -> Import Appliance"
1. Before running the appliance, go into the settings and change the following details:
  1. System/Motherboard: Raise memory to 4GB, or some rebuild operations might fail.
  1. Network/Adapter2: Ensure you have your host laptop's wifi card as "Attached to: Bridged Adapter"
  1. USB: Disable USB 2.0 and enable 1.1 instead. Some VirtualBox installations won't have the host extensions.
1. Run the appliance by right-clicking on it, then selecting "Start -> Detachable Start"
1. Open a terminal and gain root access with the password "demo".


## Some housekeeping for the Melbourne :: Compose 2019 Workshop

Let's add a couple of extra touches to make the rest of the workshop easier.
This will also serve as your introduction to the way NixOS does things.

We have prepared a local package proxy-cache for this workshop, so we're not
bottlenecked by external network access. We'll have to configure that in your
VMs. We've also configured the proxy-cache server to use the mdns name
dymaxion.local, so you'll have to configure your VMs to use avahi/mdns.

In the root terminal you opened in the previous point, please edit
`/etc/nixos/configuration.nix` (both nano and vim are available) and add the
following lines:

    ```
    # avahi/mdns/bonjour/rendezvous
    services.avahi.enable = true;
    services.avahi.nssmdns = true;

    nix.binaryCaches = [
      "http://dymaxion.local"
      "https://cache.nixos.org"
    ];
    ```
    
Exit your editor and, still as root, run the following command:

    ```
    # nixos-rebuild switch
    ```
    
Now your VM should be able to use avahi (check by running `ping dymaxion.local`
and the first source for binary packages will be the workshop proxy-cache).
We'll see how all of this works in the next section.
