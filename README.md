# Nix4Pi4

This repository gets you up and running with a flake that can build a Nix OS
image for the Raspberry Pi.

This really basic example just comes with networking, docker, and SSH preconfigured.

## Building on x86 Machines

To build on x86 machines, you will need to set up QEMU with binfmt. I've
included the Archlinux instructions for this.

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

You're good to build and flash as usual
