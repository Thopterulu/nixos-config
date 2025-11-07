{ config, lib, pkgs, ... }:

{
  # Gaming-specific firewall configuration
  networking.firewall = {
    enable = true;
    extraCommands = ''
      # Allow Total War Warhammer 3 through Proton
      iptables -A nixos-fw -p tcp --dport 27015:27030 -m owner --cmd-owner warhammer3.exe -j ACCEPT
      iptables -A nixos-fw -p udp --dport 27000:27100 -m owner --cmd-owner warhammer3.exe -j ACCEPT
      iptables -A nixos-fw -p udp --dport 3478:4380 -m owner --cmd-owner warhammer3.exe -j ACCEPT

      # Also allow for the Proton process itself
      iptables -A nixos-fw -p tcp --dport 27015:27030 -m owner --cmd-owner steam-launch-wrap -j ACCEPT
      iptables -A nixos-fw -p udp --dport 27000:27100 -m owner --cmd-owner steam-launch-wrap -j ACCEPT
      iptables -A nixos-fw -p udp --dport 3478:4380 -m owner --cmd-owner steam-launch-wrap -j ACCEPT

      # Generic Proton wine processes
      iptables -A nixos-fw -p tcp --dport 27015:27030 -m owner --cmd-owner wine64-preloader -j ACCEPT
      iptables -A nixos-fw -p udp --dport 27000:27100 -m owner --cmd-owner wine64-preloader -j ACCEPT
      iptables -A nixos-fw -p udp --dport 3478:4380 -m owner --cmd-owner wine64-preloader -j ACCEPT
    '';
  };
}