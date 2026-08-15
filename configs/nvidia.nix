# NVIDIA GPU configuration
{ config, lib, pkgs, ... }:

{
  # Enable NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    open = false;  # Proprietary modules - open modules crash on Turing (RTX 2080 Super)

    # Power management
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # Full power for gaming

    # Persistence mode: keeps the driver resident so it does not tear down and
    # re-initialise GPU state between clients, which costs latency on launch.
    # `nvidia-smi --query-gpu=persistence_mode` reported Disabled before this.
    # Uses the supported daemon rather than a one-shot `nvidia-smi -pm 1`, which
    # does not survive driver reload.
    nvidiaPersistenced = true;

    # Performance settings
    forceFullCompositionPipeline = false;  # Reduces input lag

    # NO PRIME BLOCK, deliberately. This used to configure offload because the
    # Intel iGPU drove the secondary screen and NVIDIA drove the main one. Every
    # display is now cabled to the NVIDIA card (card2: DP-4 Samsung, HDMI-A-4
    # Dell) and every card1 connector reads "disconnected", so there is no
    # hybrid setup left to arbitrate. PRIME is a laptop/hybrid mechanism; on a
    # desktop where one GPU drives everything it is vestigial config that only
    # misleads. Nothing in the repo referenced the `nvidia-offload` wrapper that
    # enableOffloadCmd provided, so dropping it breaks no callers.
    #
    # The iGPU is intentionally left enabled (i915 still loads, it just drives
    # nothing) — it is the recovery path if the NVIDIA card ever fails: cable a
    # monitor to the motherboard and the box still boots to a display.
  };

  # NVIDIA-specific kernel parameters
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"  # Fixes random frame drops
    "pcie_port_pm=off"                  # Prevent GPU falling off PCIe bus under load
  ];
}
