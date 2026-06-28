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
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor issues on NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # NVIDIA explicit sync optimization (driver 555+)
    __GL_SYNC_TO_VBLANK = "0";  # Let VRR/explicit sync handle it
    __GL_YIELD = "USLEEP";  # Better CPU usage, fixes menu stuttering

    # Shader disk cache — default 128 MB is far too small for modern games,
    # causing Steam to re-process Vulkan shaders nearly every reboot.
    # Bumped to 12 GB; shared by OpenGL and the NVIDIA Vulkan ICD.
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
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
