{
  description = "NixOS configuration de thopter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nur, nix-index-database, ... }:
    let
      # Patch hyprshell so the launcher's Ctrl+1..9 fire on French AZERTY,
      # where the unshifted top row produces ampersand/eacute/... not _1.._9.
      hyprshellAzertyOverlay = final: prev: {
        hyprshell = prev.hyprshell.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ./patches/hyprshell-azerty-launcher.patch ];
        });
      };
      overlays = [ nur.overlays.default hyprshellAzertyOverlay ];
    in {
    # Standalone Home Manager — works on any Linux with Nix
    homeConfigurations.thopter = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; inherit overlays; };
      modules = [
        ./home.nix
        {
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
          nix-index-database.nixosModules.nix-index
          {
            nixpkgs.overlays = overlays;
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
          nix-index-database.nixosModules.nix-index
          {
            nixpkgs.overlays = overlays;
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
