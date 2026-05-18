{
  description = "NixOS configuration de thopter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nur, ... }: {
    # Standalone Home Manager — works on any Linux with Nix
    homeConfigurations.thopter = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        ./home.nix
        {
          nixpkgs.overlays = [ nur.overlays.default ];
          home.username = "thopter";
          home.homeDirectory = "/home/thopter";
        }
      ];
      extraSpecialArgs = { inherit nixvim; };
    };

    nixosConfigurations = {
      thopter-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/hardware-desktop.nix
          ./configs/configuration-desktop.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.thopter = { imports = [ ./home.nix ./home-personal.nix ]; };
            home-manager.extraSpecialArgs = { inherit nixvim; };
          }
        ];
      };

      thopter-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/laptop.nix
          ./configs/configuration-laptop.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ nur.overlays.default ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.thopter = { imports = [ ./home.nix ./home-personal.nix ]; };
            home-manager.extraSpecialArgs = { inherit nixvim; };
          }
        ];
      };
    };
  };
}
