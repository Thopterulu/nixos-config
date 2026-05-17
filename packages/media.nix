{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vlc    # Video and audio player
    gimp   # Image editor
    ffmpeg # Audio/video encoding and conversion
  ];
}
