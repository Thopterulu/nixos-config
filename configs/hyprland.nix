# Wayland configuration
{ config, lib, pkgs, inputs,... }:

{
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
    # NOTE: WLR_NO_HARDWARE_CURSORS was removed here. It was a no-op anyway
    # (Hyprland 0.55 uses Aquamarine, not wlroots), and the intent behind it was
    # wrong: software cursors block direct scanout and caused mouse stutter in
    # cs2. The real setting is cursor.no_hardware_cursors in
    # dotfiles/hypr/hyprland.lua, now false. Do not reintroduce either.
    # Pin Hyprland's (Aquamarine's) GPU enumeration order: NVIDIA first, so it is
    # deterministically the primary render device. Without this, card numbering
    # on a dual-GPU box is not guaranteed stable across boots, and everything
    # that matters for gaming (direct scanout on DP-4) assumes NVIDIA is primary.
    # by-path is used deliberately — /dev/dri/cardN is exactly the unstable name
    # this is meant to defend against. PCI addresses match nvidia.nix busIds.
    #   pci-0000:01:00.0 = RTX 2080 SUPER   pci-0000:00:02.0 = UHD 630
    # The iGPU stays listed second: it still drives HDMI-A-1 (the Dell).
    AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card:/dev/dri/by-path/pci-0000:00:02.0-card";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    # Both are X11-only knobs and have no effect under Wayland. Kept as
    # documentation of intent; VRR is unreachable here regardless, because the
    # proprietary driver never exposes the `vrr_capable` connector property.
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # NVIDIA explicit sync optimization (driver 555+)
    # The original rationale ("let VRR handle it") is void — there is no working
    # VRR on this hardware. Left at 0 because it predates the stutter fix and
    # changing it is untested; revisit if frame pacing regresses.
    __GL_SYNC_TO_VBLANK = "0";
    __GL_YIELD = "USLEEP";  # Better CPU usage, fixes menu stuttering

    # Shader disk cache — default 128 MB is far too small for modern games,
    # causing Steam to re-process Vulkan shaders nearly every reboot.
    # Bumped to 24 GB; shared by OpenGL and the NVIDIA Vulkan ICD.
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = "24000000000";
    DXVK_STATE_CACHE = "1";

    # Enable Wayland for Electron/Chrome apps (VSCode, Discord, Obsidian...)
    NIXOS_OZONE_WL = "1";

    # Enable Wayland for Qt apps (KeePassXC, VLC...)
    QT_QPA_PLATFORM = "wayland;xcb";

    # GTK apps auto-detect Wayland on Hyprland — do NOT set GDK_BACKEND
    # globally, it breaks layer-shell apps like Hyprshell and Waybar

    # Enable Wayland for SDL apps (games, mixxx...)
    # NOTE: "wayland,x11" fallback syntax is supported since SDL 2.0.22+
    SDL_VIDEODRIVER = "wayland,x11";

    # Enable Wayland for Clutter-based apps
    CLUTTER_BACKEND = "wayland";

    # XKB keyboard layout for Wayland
    XKB_DEFAULT_LAYOUT = "fr";
    XKB_DEFAULT_MODEL = "pc105";
    XKB_DEFAULT_OPTIONS = "caps:escape";
  };

  # Wayland-specific packages
  environment.systemPackages = with pkgs; [
    qt6.qtwayland        # Qt6 Wayland platform plugin
    wl-clipboard         # Wayland clipboard utilities
    copyq                # Clipboard manager with GUI and tray icon
    xwayland             # X11 compatibility layer
    wofi                 # App launcher for Wayland
    waybar               # Status bar for Wayland
    grim                 # Screenshot tool for Wayland
    slurp                # Region selector for Wayland
    grimblast            # Screenshot wrapper for Hyprland
    swappy               # Screenshot annotation tool
    # WARNING: nwg-displays writes ~/.config/hypr/monitors.conf, and NOTHING
    # READS IT. The Lua config manager has no hl.source() for hyprlang files, so
    # monitors are hardcoded in dotfiles/hypr/hyprland.lua instead. This GUI will
    # appear to work and silently change nothing. Edit hyprland.lua by hand, or
    # drop this package.
    nwg-displays         # GUI display configuration tool for Hyprland
    jq                   # JSON processor for waybar scripts
    hyprpicker           # Color picker for Wayland
    hyprlock             # Screen locker for Hyprland
    hypridle             # Idle daemon for Hyprland
    brightnessctl        # Screen brightness control
    awww                 # Wallpaper daemon with smooth transitions
    #hyprshell            # Hyprland alt tab launcher
  ];
}
