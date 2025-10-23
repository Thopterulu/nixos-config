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
    prime = {
      # PRIME sync: NVIDIA renders, Intel outputs to displays
      sync.enable = true;

      nvidiaBusId = "PCI:1@0:0:0";   # 01:00.0
      intelBusId = "PCI:0@0:2:0";    # 00:02.0
    };
  };

  # Desktop-specific display configuration
  services.xserver.displayManager.sessionCommands = ''
   sleep 1
   xrandr --output DP-1-2 --primary --mode 2560x1440 --rate 120 --pos 0x0 \
         --output HDMI-1 --mode 1920x1080 --rate 60 --pos 2560x0 &

   xset r rate 200 35 &
  '';

  # Gaming performance tweaks (desktop only)
  powerManagement.cpuFreqGovernor = "performance";
  programs.corectrl.enable = true;

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "mitigations=off"
  ];

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
  ];
}
