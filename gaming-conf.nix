{ config, lib, pkgs, ... }:

{
  # Gaming-specific firewall configuration
  networking.firewall = {
    enable = true;
    extraCommands = ''
      # Allow Total War Warhammer 3 for your user
      iptables -A nixos-fw -p tcp --dport 27015:27030 -m owner --uid-owner thopter -j ACCEPT
      iptables -A nixos-fw -p udp --dport 27000:27100 -m owner --uid-owner thopter -j ACCEPT
      iptables -A nixos-fw -p udp --dport 3478:4380 -m owner --uid-owner thopter -j ACCEPT
    '';
  };
}