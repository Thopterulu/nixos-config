# Desktop-only configuration with gaming optimizations
{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./nvidia.nix
  ];


  # Gaming performance tweaks (desktop only)
  powerManagement.cpuFreqGovernor = "performance";
  programs.corectrl.enable = true;

  # Gaming-specific kernel parameters
  boot.kernelParams = [
    "mitigations=off"       # Disable CPU vulnerability mitigations for performance
    "vsyscall=emulate"      # Fix for old Windows games crashing
  ];

  # System optimizations for consistent performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;           # Reduce swapping
    "vm.vfs_cache_pressure" = 50;  # Reduce cache pressure
    "kernel.sched_migration_cost_ns" = 5000000;  # Reduce scheduler overhead
  };

  # Gaming optimizations
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    gamemode
    mangohud
    gamescope
    goverlay
    gwe  # GreenWithEnvy - GPU overclocking tool
    streamcontroller  # streamdeck controller
  ];
}
