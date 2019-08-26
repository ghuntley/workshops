# Prerequisites

## 📖 Overview

If you are doing this workshop as part of a classroom, it is important to
pre-install these components before attendance as you'll need to download
upwards of 4Gb of software from the internet.

## ☑️ Software Installation

Attendees will need a computer with Virtual Box installed:

* [ ] Download the [NixOS demo appliance][download-nixos-ova] for VirtualBox (in
      OVA format) that has X11 and Plasma 5 enabled.
* [ ] Download the [NixOS graphical installation ISO][download-nixos-iso] which
      contains the NixOS installer.
* [ ] Download and install [VirtualBox][download-virtualbox].
* [ ] Download and install [VirtualBox Extension Pack][download-virtualbox-extension-pack].

## ☑️ Configuration

If you are installing NixOS on a laptop as it's primary operating system then
you'll need to [burn the installation ISO to a USB drive or DVD][burn-the-iso].
Alternatively, if you are going to use Virtual Box then you'll need to import
the image and adjust the default settings:

* [ ] In VirtualBox, use the menu option `File -> Import Appliance` and import
      the [NixOS demo appliance][download-nixos-ova].

In Virtual Box, with the appliance turned off, go into the virtual machine
   settings and change the following details:

* [ ] **System/Motherboard**: Raise memory to 4GB or 8GB, or some
      `nixos-rebuilt` or `nix-env` operations might fail.
* [ ] **Network/Adapter2**: Ensure you have your host laptop's WiFi card as
      `Attached to: Bridged Adapter`
* [ ] **USB**: Disable USB 2.0 and enable 1.1 instead.

Windows users, if Hyper-V is enabled on your computer [you'll need to follow
these steps][bcd-edit] from Scott Hansleman before VirtualBox will work on your
computer.

## What's next

🎉 that's it. Your now ready to learn all about the NixOS operating system. In
the [next module][next-module] you'll learn all about NixOS and install the
operating system.

<!-- in-line links -->
[burn-the-iso]: https://nixos.org/nixos/manual/index.html#sec-booting-from-usb
[bcd-edit]: https://www.hanselman.com/blog/SwitchEasilyBetweenVirtualBoxAndHyperVWithABCDEditBootEntryInWindows81.aspx

[download-virtualbox]: https://www.virtualbox.org/wiki/Downloads
[download-virtualbox-extension-pack]: https://download.virtualbox.org/virtualbox/6.0.10/Oracle_VM_VirtualBox_Extension_Pack-6.0.10.vbox-extpack
[download-nixos-iso]: https://releases.nixos.org/nixos/19.03/nixos-19.03.173307.776d66ec115/nixos-graphical-19.03.173307.776d66ec115-x86_64-linux.iso
[download-nixos-ova]: https://releases.nixos.org/nixos/19.03/nixos-19.03.173251.56d94c8c69f/nixos-19.03.173251.56d94c8c69f-x86_64-linux.ova

[next-module]: ../01-introduction-to-nixos/README.md
