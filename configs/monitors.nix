# Monitor configuration for SDDM and Hyprland
{ config, lib, pkgs, ... }:

let
  # Monitor setup script for SDDM
  monitorSetupScript = pkgs.writeShellScript "sddm-monitor-setup" ''
    # This script ensures SDDM displays on DP-4 (DisplayPort) instead of HDMI-A-4 (projector)

    # For Wayland SDDM sessions, we need to configure the compositor
    # KWin (SDDM's default Wayland compositor) uses these environment variables

    export KWIN_DRM_PRIORITY="DP-4,HDMI-A-1,HDMI-A-4"

    # Alternative: Use wlr-randr for wlroots-based compositors
    if command -v wlr-randr &> /dev/null; then
      # Disable HDMI-A-4 (projector) and enable DP-4 as primary
      wlr-randr --output HDMI-A-4 --off || true
      wlr-randr --output DP-4 --on --preferred || true
    fi
  '';
in
{
  # SDDM configuration
  services.displayManager.sddm = {
    # Use Wayland compositor
    wayland.compositor = "kwin";

    settings = {
      General = {
        DisplayServer = "wayland";
      };

      # Configure Wayland session
      Wayland = {
        # This environment file is sourced before starting the compositor
        CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
      };

      # X11 fallback configuration (in case Wayland doesn't work)
      X11 = {
        # This script runs before starting the X server
        DisplayCommand = "${pkgs.writeShellScript "sddm-xsetup" ''
          # Configure monitors using xrandr
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --primary --auto || true
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-4 --off || true
        ''}";
      };
    };
  };

  # Environment variables for the display manager
  # These help ensure the correct monitor is used
  environment.sessionVariables = {
    # Prefer DisplayPort outputs over HDMI
    KWIN_DRM_DEVICES = "/dev/dri/card0";
  };

  # Systemd service to ensure DRM devices are ready with correct priority
  # This creates a udev rule to prioritize DP outputs
  services.udev.extraRules = ''
    # Prioritize DisplayPort connectors over HDMI for display managers
    # This helps SDDM choose DP-4 instead of HDMI-A-4
    SUBSYSTEM=="drm", KERNEL=="card0-DP-*", ENV{DISPLAY_PRIORITY}="10"
    SUBSYSTEM=="drm", KERNEL=="card0-HDMI-*", ENV{DISPLAY_PRIORITY}="5"
  '';

  # Ensure required packages are available
  environment.systemPackages = with pkgs; [
    wlr-randr  # Wayland display configuration tool
  ];
}
