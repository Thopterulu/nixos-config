# NVIDIA GPU configuration
{ config, lib, pkgs, ... }:

{
  # Enable NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    open = true;  # Use open-source kernel modules

    # Power management
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # Full power for gaming

    # Performance settings
    forceFullCompositionPipeline = false;  # Reduces input lag

    # PRIME configuration for hybrid graphics
    # prime = {
    #   # PRIME sync: NVIDIA renders, Intel outputs to displays
    #   sync.enable = true;
    #   nvidiaBusId = "PCI:1@0:0:0";   # 01:00.0
    #   intelBusId = "PCI:0@0:2:0";    # 00:02.0
    # };
  };

  # NVIDIA-specific kernel parameters
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"  # Fixes random frame drops
  ];
}
