{ config, lib, pkgs, ... }:

{
  # Enable PC/SC daemon for smart card readers
  services.pcscd = {
    enable = true;
    # Enable debugging if you need to troubleshoot
    # extraArgs = [ "-d" ];
  };

  # Add user to scard group for smart card access
  users.users.thopter.extraGroups = [ "scard" ];

  # Install smart card related packages
  environment.systemPackages = with pkgs; [
    # PC/SC tools for testing and monitoring card readers
    pcsc-tools       # Includes pcsc_scan, ATR_analysis, etc.

    # OpenSC for smart card support
    opensc           # Tools and libraries for smart cards

    # GPG for smart card operations
    gnupg

    # Java runtime for Oura smart card plugin
    jre              # Java Runtime Environment

    # CCID driver is included by default with pcscd
  ];

  # Hardware support for CCID-compatible readers (IDBridge CT30 is CCID compliant)
  hardware.gpgSmartcards.enable = true;
}
