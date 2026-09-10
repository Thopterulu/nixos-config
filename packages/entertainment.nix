{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord              # Voice/text chat
    mixxx                # DJ mixing software
    scdl                 # SoundCloud track downloader
    davinci-resolve      # Professional video editor
    shotcut              # Open-source video editor
    kdePackages.kdenlive # KDE video editor
    homebank             # Personal finance manager
    neothesia            # Piano MIDI visualizer (falling notes)
    linthesia            # Synthesia-style player with wait-for-note practice mode
    alsa-utils           # aconnect/amidi for MIDI routing & debugging
  ];
}
