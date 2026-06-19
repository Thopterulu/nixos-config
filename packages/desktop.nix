{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ghostty      # GPU-accelerated terminal emulator (Wayland-native)
    pcmanfm      # Lightweight file manager
    rofi         # Application launcher / window switcher
    dunst        # Lightweight notification daemon
    xwallpaper   # Wallpaper setter for X11
    opensnitch-ui # Application firewall GUI
    bubblewrap   # Lightweight sandboxing tool
    i3lock-fancy # Screen locker with blur effect
    file-roller  # GTK4 archive manager (Wayland-native)
    p7zip        # 7z/zip/tar/iso backend for file-roller
    unrar        # RAR support (unfree)
  ];
}
