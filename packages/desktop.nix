{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty    # GPU-accelerated terminal emulator
    pcmanfm      # Lightweight file manager
    rofi         # Application launcher / window switcher
    flameshot    # Screenshot tool with annotation
    dunst        # Lightweight notification daemon
    xwallpaper   # Wallpaper setter for X11
    opensnitch-ui # Application firewall GUI
    bubblewrap   # Lightweight sandboxing tool
    i3lock-fancy # Screen locker with blur effect
  ];
}
