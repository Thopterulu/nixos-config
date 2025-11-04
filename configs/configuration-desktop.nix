# Desktop-only configuration with NVIDIA and gaming optimizations
{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration.nix
  ];

  # NVIDIA configuration (desktop only)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # Full power for gaming
    forceFullCompositionPipeline = false; # Reduces input lag
    prime = {
      # PRIME sync: NVIDIA renders, Intel outputs to displays
      sync.enable = true;

      nvidiaBusId = "PCI:1@0:0:0";   # 01:00.0
      intelBusId = "PCI:0@0:2:0";    # 00:02.0
    };
  };

  # Desktop-specific display configuration
  services.xserver.displayManager.sessionCommands = ''
   xset r rate 200 35 &
   # Apply autorandr profile after X11 is ready
   (sleep 2 && autorandr --change) &
  '';

  # AutoRandr for reliable display management
  services.autorandr = {
    enable = true;
    defaultTarget = "desktop";
  };

  # Gaming performance tweaks (desktop only)
  powerManagement.cpuFreqGovernor = "performance";
  programs.corectrl.enable = true;

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"  # Fixes random frame drops
    "mitigations=off"
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
