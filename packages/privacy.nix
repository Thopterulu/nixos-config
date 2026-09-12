{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tor                  # Anonymous network relay
    tor-browser          # Privacy-focused web browser
    proton-vpn           # VPN client
  ];
}
