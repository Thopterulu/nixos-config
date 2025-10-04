{
  description = "NixOS configuration de thopter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.thopter-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        /etc/nixos/hardware-configuration.nix  # Reste dans /etc/nixos
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.thopter = import ./home.nix;
        }
      ];
    };
  };
}
