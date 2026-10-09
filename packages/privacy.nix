{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tor                  # Anonymous network relay
    tor-browser          # Privacy-focused web browser
    mullvad-browser      # Tor Browser hardening, without the Tor network
    proton-vpn           # VPN client
  ];
}
