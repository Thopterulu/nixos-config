# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # allow unfree
  nixpkgs.config.allowUnfree = true;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "snd-usb-audio" ];


  networking.hostName = "thopter-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "fr";
  #  useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    xkb.layout = "fr";
    xkb.options = "eurosign:e,caps:escape";
    displayManager.sessionCommands = ''
      xset r rate 200 35 &
    '';
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure keymap in X11

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;  # Émulation PulseAudio
    jack.enable = true;   # Optionnel

    # Configuration spécifique
    wireplumber.enable = true;


  };

  # Pour le gaming
  security.rtkit.enable = true;
  security.pam.services.betterlockscreen = {};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thopter = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" ]; # Enable 'sudo' for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.fuse.userAllowOther = true;
  programs.zsh.enable = true;
  # Enable Docker
  virtualisation.docker.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    alacritty
    refind
    btop
    xwallpaper
    pcmanfm
    rofi
    steam
    discord
    git
    neofetch
    xclip
    keepassxc
    rclone
    flameshot
    dunst
    ntfs3g
    pciutils
    pavucontrol       # GUI pour gérer l'audio (RECOMMANDÉ)
    helvum            # Patchbay graphique PipeWire
    qpwgraph          # Alternative à Helvum
    easyeffects       # EQ et effets audio
    pulseaudio
    # Monitoring
    pwvucontrol       # Contrôle PipeWire modern
    gcc
    gnumake
    pkg-config
    cryptomator
    direnv
    zip
    unzip
    homebank
    vscode
    playerctl
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts-emoji
    nerd-fonts.jetbrains-mono
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; # Did you read the comment?

}

