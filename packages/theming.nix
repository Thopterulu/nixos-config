{ pkgs, ... }:

{
  home.packages = with pkgs; [
    arc-theme          # Flat GTK theme
    papirus-icon-theme # Material Design icon theme
    lxappearance       # GTK theme switcher GUI
    tumbler            # Thumbnail generator for file managers
    ffmpegthumbnailer  # Video thumbnail generator
  ];
}
