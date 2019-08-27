# Prerequisites

## 📖 Overview

Attendees will need a computer with either Linux, macOS or Windows 10 (with WSL enabled and Ubuntu installed) installed on it.

## ☑️ NixOS

No configuration needed as the nix package manager is already installed! 🎉

## ☑️ Debian, Ubuntu, Arch, RedHat and macOS

* [ ] Download and install the [latest recommended version][download-nix] of the Nix Package Manager which is currently `v2.2.2`:

```bash
curl -o install-nix-2.2.2 https://nixos.org/nix/install
curl -o install-nix-2.2.2.sig https://nixos.org/nix/install.sig
gpg2 --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
gpg2 --verify ./install-nix-2.2.2.sig
sh ./install-nix-2.2.2
```

If a [newer version is available][download-nix], install that instead and send in a pull-request to update this document.

## ☑️ Windows 10

> ✋ If you are doing this workshop as part of a classroom on a windows computer, it is important to pre-install these components before attendance as you'll need to download upwards of 3Gb of software from the internet.

* [ ] [Developer Mode in Windows 10 enabled](https://docs.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development)
* [ ] [Install the Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* [ ] [Install Ubuntu 18.04 LTS for Windows Subsystem for Linnux](https://www.microsoft.com/en-au/p/ubuntu-1804-lts/9n9tngvndl3q?rtc=1&activetab=pivot:overviewtab)

* [ ] Login to Ubuntu via WSL, download and install the [latest recommended version][download-nix] of the Nix Package Manager which is currently `v2.2.2`:

```bash
curl -o install-nix-2.2.2 https://nixos.org/nix/install
curl -o install-nix-2.2.2.sig https://nixos.org/nix/install.sig
gpg2 --recv-keys B541D55301270E0BCF15CA5D8170B4726D7198DE
gpg2 --verify ./install-nix-2.2.2.sig
sh ./install-nix-2.2.2
```

If a [newer version is available][download-nix], install that instead and send in a pull-request to update this document.


## What's next

🎉 that's it. You're now ready to learn all about the nix package manager, nix language and how to use utilize them to achieve incredible things. In the [next module][next-module] you'll learn all about the nix package manager.

<!-- in-line links -->
[download-nix]: https://nixos.org/nix/download.html

[next-module]: ../01-introduction-to-nix/README.md
