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

  # Hardware video decode on the NVIDIA card. Nothing provided VA-API before:
  # intel-media-driver is in configuration.nix, but every display is cabled to
  # the NVIDIA card and the iGPU drives nothing, so browsers and mpv were
  # decoding H.264/HEVC/AV1 on the CPU. Requires nvidia_drm.modeset=1, already
  # set below.
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  # LIBVA_DRIVER_NAME=nvidia is NOT set here — hyprland.nix already sets it.
  environment.sessionVariables = {
    # Direct backend imports NVDEC surfaces without a CUDA context. The default
    # "egl" path needs a GL context the caller may not have; "direct" is what
    # upstream recommends since 0.0.10 and what Firefox/mpv expect.
    NVD_BACKEND = "direct";
  };

  # vainfo, to verify the above actually took.
  environment.systemPackages = [ pkgs.libva-utils ];

  # NVIDIA-specific kernel parameters
  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_EnableGpuFirmware=0"  # Fixes random frame drops
    "pcie_port_pm=off"                  # Prevent GPU falling off PCIe bus under load
  ];
}
