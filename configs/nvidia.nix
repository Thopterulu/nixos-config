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

    # PRIME offload: Both GPUs drive their own displays independently
    # Intel for secondary screen, NVIDIA for main screen + projector
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1@0:0:0";   # 01:00.0
      intelBusId = "PCI:0@0:2:0";    # 00:02.0
    };
  };

  # NVIDIA-specific kernel parameters
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"  # Fixes random frame drops
  ];
}
