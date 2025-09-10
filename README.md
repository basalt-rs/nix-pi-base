# Nix4Pi4

This repository gets you up and running with a flake that can build a Nix OS
image for the Raspberry Pi.

This really basic example just comes with networking, docker, and SSH preconfigured.

## Setup

1. Clone the repo

```sh
git clone https://github.com/basalt-rs/nix-pi-base.git && cd nix-pi-base
```

2. Setup

```sh
make setup-pathing # update paths in `flake.nix`
make setup-config # create configuration files
```

3. Build

Build according to your architecture, but different operating systems
might have additional requirements. You'll likely want to use QEMU to
cross-compile if necessary.

## Building on x86 Machines

To build on x86 machines, you will need to set up QEMU with binfmt. I've
included the Archlinux instructions for this.

1. Build

```sh
make build
```

2. Flash

```sh
# replace /dev/sda with your intended device target
make flash DEVICE=/dev/sda
```

3. Eject

```sh
# You can do this manually to if you'd like or need.
make safe-eject
```

4. Plug and Play

Booting up your Pi with your SD card inserted should cause your Pi to boot
into your NixOS image. If you're fully headless, use `nmap` or `arp-scan` to
find it on your network. Then you're good to SSH.

> [!NOTE]
> If you end up rebuilding and reflashing, you may need to remove the device
> from your known SSH hosts (`~/.ssh/known_hosts`) or SSH may yell at you.

### Archlinux

1. Add `extra-platforms` to `/etc/nix/nix.conf`

```conf
extra-platforms = aarch64-linux
```

2. Install Deps

```sh
sudo pacman -S qemu-user-static qemu-user-static-binfmt
```

3. Build

You're good to build and flash as usual!
