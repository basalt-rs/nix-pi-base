{
  description = "Base system for raspberry pi 4";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    networking-config = {
      # Update this path
      url = "path:/home/jack/dev/nix-pi-base/config/networking.toml";
      flake = false;
    };
    user-config = {
      # Update this path
      url = "path:/home/jack/dev/nix-pi-base/config/users.toml";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixos-generators, networking-config, user-config, ... }:
  {
    nixosModules = {
      system = {
        imports = [
          ./ap.nix
          ./networking.nix
          ./users.nix
          ./security.nix
        ];
        # disabledModules = [
        #   "profiles/base.nix"
        # ];
        systemd.network.wait-online.enable = true;

        system.stateVersion = "23.11";

        # Enable Docker
        virtualisation.docker.enable = true;
        users.extraGroups.docker.members = [ "jack" ];

        # Enable SSH
        services.openssh = {
          enable = true;
          permitRootLogin = "no";
          passwordAuthentication = false;
        };

        boot.kernelParams = [ "console=tty1" ];
      };
    };

    packages.aarch64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        specialArgs = {
          inherit networking-config user-config;
        };
        modules = [
          self.nixosModules.system
        ];
      };
    };
  };
}
