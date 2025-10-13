{
  description = "NixOS configuration de thopter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }: {
    nixosConfigurations = {
      thopter-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/hardware-desktop.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thopter = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit nixvim; };
          }
        ];
      };

      thopter-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/hardware-laptop.nix
          ./configuration-laptop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thopter = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit nixvim; };
          }
        ];
      };
    };
  };
}
