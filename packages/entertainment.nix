{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord              # Voice/text chat
    mixxx                # DJ mixing software
    scdl                 # SoundCloud track downloader
    tor                  # Anonymous network relay
    tor-browser          # Privacy-focused web browser
    davinci-resolve      # Professional video editor
    shotcut              # Open-source video editor
    kdePackages.kdenlive # KDE video editor
    homebank             # Personal finance manager
  ];
}
