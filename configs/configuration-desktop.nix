# Desktop-only configuration with gaming optimizations
{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./nvidia.nix
  ];


  # Gaming performance tweaks (desktop only)
  powerManagement.cpuFreqGovernor = "performance";
  # corectrl removed: AMD-focused tool; gwe (GreenWithEnvy) covers the Nvidia side here.

  # Gaming-specific kernel parameters
  boot.kernelParams = [
    "mitigations=off"       # Disable CPU vulnerability mitigations for performance
    "vsyscall=emulate"      # Fix for old Windows games crashing
    "quiet"                 # Suppress most boot messages
    "splash"                # Enable boot splash screen
  ];

  # Suppress kernel log messages on console
  boot.consoleLogLevel = 3;  # Only show errors and critical messages

  # System optimizations for consistent performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 1;           # Reduce swapping
    "vm.vfs_cache_pressure" = 50;  # Reduce cache pressure
    "kernel.sched_migration_cost_ns" = 5000000;  # Reduce scheduler overhead
    # Required by BG3, Star Citizen, Hogwarts Legacy, many DX12 / Source 2
    # titles. Value matches Steam Deck's default (INT32_MAX - 5).
    "vm.max_map_count" = 2147483642;
  };

  # Gaming optimizations
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;               # CPU priority boost on activation
        ioprio = 0;                # Best I/O priority class (real-time)
        inhibit_screensaver = 1;
      };
      cpu = {
        park_cores = "no";         # Keep all cores active (mitigations=off already)
        pin_cores = "no";          # Let the scheduler place threads
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1;    # Nvidia "Prefer maximum performance"
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send -t 2000 'GameMode' 'Activated'";
        end   = "${pkgs.libnotify}/bin/notify-send -t 2000 'GameMode' 'Deactivated'";
      };
    };
  };
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    # protontricks: GUI/CLI for fixing per-game Wine prefixes (winetricks-on-Proton).
    protontricks.enable = true;
    # extest: shim that fixes X11 input grabbing in some XInput2-only games.
    extest.enable = true;
  };

  # udev rules for PS4/PS5/Switch Pro/Stadia/8BitDo/etc. controllers.
  # xpadneo (bluetooth.nix) already covers Xbox.
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

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
