# Wayland configuration
{ config, lib, pkgs, inputs,... }:

{
  # Enable Wayland support in SDDM
  services.displayManager.sddm.wayland.enable = true;

  # XWayland for running X11 apps on Wayland (Steam, games, etc)
  programs.xwayland.enable = true;

  # Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  # Wayland environment variables for better compatibility
  environment.sessionVariables = {
    # NVIDIA Wayland support - fix flickering and performance
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor issues on NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # NVIDIA explicit sync optimization (driver 555+)
    __GL_SYNC_TO_VBLANK = "0";  # Let VRR/explicit sync handle it
    __GL_YIELD = "USLEEP";  # Better CPU usage, fixes menu stuttering

    # Enable Wayland for Electron/Chrome apps
    NIXOS_OZONE_WL = "1";

    # XKB keyboard layout for Wayland
    XKB_DEFAULT_LAYOUT = "fr";
    XKB_DEFAULT_OPTIONS = "eurosign:e,caps:escape";
  };

  # Wayland-specific packages
  environment.systemPackages = with pkgs; [
    wl-clipboard         # Wayland clipboard utilities
    xwayland             # X11 compatibility layer
    kitty                # Terminal for Hyprland
    wofi                 # App launcher for Wayland
    kdePackages.dolphin  # KDE file manager
    waybar               # Status bar for Wayland
    grim                 # Screenshot tool for Wayland
    slurp                # Region selector for Wayland
    jq                   # JSON processor for waybar scripts
    hyprpicker           # Color picker for Wayland
    hyprlock             # Screen locker for Hyprland
    #hyprshell            # Hyprland alt tab launcher
  ];
}
