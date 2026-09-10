{ pkgs, ... }:

{
  home.packages = with pkgs; [
    mullvad               
    mullvad-vpn          # VPN client
    tor                  # Anonymous network relay
    tor-browser          # Privacy-focused web browser
    proton-vpn           # VPN client
  ];
}
