# Wayland configuration
{ config, lib, pkgs, ... }:

{
  # Enable Wayland support in SDDM
  services.displayManager.sddm.wayland.enable = true;

  # XWayland for running X11 apps on Wayland (Steam, games, etc)
  programs.xwayland.enable = true;

  # Wayland environment variables for better compatibility
  environment.sessionVariables = {
    # NVIDIA Wayland support
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor issues on NVIDIA
    # Enable Wayland for Electron/Chrome apps
    NIXOS_OZONE_WL = "1";
  };

  # Wayland-specific packages including qtile wayland backend
  environment.systemPackages = with pkgs; [
    wl-clipboard      # Wayland clipboard utilities
    xwayland          # X11 compatibility layer
  ];
}
