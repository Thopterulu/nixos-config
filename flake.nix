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
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/Hyprland-Plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nur, ... }: {
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
            home-manager.users.thopter = import ./home.nix;
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
            home-manager.users.thopter = import ./home.nix;
            home-manager.extraSpecialArgs = { inherit nixvim; };
          }
        ];
      };
    };
  };
}
