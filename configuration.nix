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
    videoDrivers = [ "nvidia" ];
    windowManager.qtile.enable = true;
    xkb.layout = "fr";
    xkb.options = "eurosign:e,caps:escape";
    displayManager.sessionCommands = ''
   xrandr --setprovideroutputsource modesetting NVIDIA-0 &
   sleep 1
   xrandr --output DP-2 --primary --mode 2560x1440 --rate 120 --pos 0x0 \
         --output HDMI-1-1 --mode 1920x1080 --rate 60 --pos 2560x0 &

   # Add 4:3 resolutions for Counter-Strike
   xrandr --newmode "1440x1080_120.00" 296.70 1440 1544 1696 1952 1080 1083 1088 1135 -hsync +vsync &
   xrandr --addmode DP-2 1440x1080_120.00 &
   xrandr --newmode "1280x960_120.00" 233.45 1280 1376 1512 1744 960 963 967 1006 -hsync +vsync &
   xrandr --addmode DP-2 1280x960_120.00 &
   xrandr --newmode "1024x768_120.00" 150.00 1024 1096 1200 1376 768 771 775 803 -hsync +vsync &
   xrandr --addmode DP-2 1024x768_120.00 &

   ${pkgs.bash}/bin/bash /home/thopter/nixos-config/scripts/wallpaper-changer.sh &
   xset r rate 200 35 &
    '';
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = false;
    prime = {
      # Reverse PRIME : NVIDIA rend et envoie au GPU intégré
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";   # 01:00.0
      intelBusId = "PCI:0:2:0";    # 00:02.0
    };
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

  # Gaming optimizations
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
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
    # Gaming optimizations
    gamemode
    mangohud
    gamescope
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

