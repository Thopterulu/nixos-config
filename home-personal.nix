{ config, pkgs, ... }:

{
  imports = [
    ./packages/gaming.nix
    ./packages/entertainment.nix
    ./packages/mpc-autofill.nix
  ];
}
