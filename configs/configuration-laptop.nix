# Laptop-only configuration - no NVIDIA, single screen
{ config, lib, pkgs, ... }:

{
  imports = [
    ./configuration.nix
  ];

  # Override hostname for laptop
  networking.hostName = lib.mkForce "thopter-laptop";
  networking.networkmanager.enable = true;
  # Disable NVIDIA completely for laptop
  services.xserver.videoDrivers = lib.mkForce [ ];
  hardware.nvidia = lib.mkForce { };

  # Simple display setup - no multi-monitor xrandr commands
  services.xserver.displayManager.sessionCommands = lib.mkForce ''
    ${pkgs.bash}/bin/bash /home/thopter/nixos-config/scripts/wallpaper-changer.sh &
    xset r rate 200 35 &
  '';

  # Enable touchpad for laptop
  services.libinput.enable = true;

  # Add networkmanager group for WiFi
  users.users.thopter.extraGroups = lib.mkForce [ "wheel" "audio" "docker" "networkmanager" ];

  # Add laptop-specific packages
  environment.systemPackages = with pkgs; [
    brightnessctl    # Screen brightness control
    acpi            # Battery info
    powertop        # Power management
  ];

  # Enable power management
  services.tlp.enable = true;

}
