{ config, pkgs, ... }:

{
  imports = [
    ./packages/gaming.nix
    ./packages/entertainment.nix
    ./packages/privacy.nix
    ./packages/mpc-autofill.nix
  ];
}
