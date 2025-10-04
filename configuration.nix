# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # allow unfree
  nixpkgs.config.allowUnfree = true; 


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
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
   xwallpaper --output DP-2 --zoom ~/wallpapers/streets.jpg \
             --output HDMI-1-1 --zoom ~/wallpapers/streets.jpg &
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
    open = true;
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
# Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thopter = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
 environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
   google-drive-ocamlfuse
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
   pwvucontrol       # Contrôle PipeWire moderne
];

 fonts.packages = with pkgs; [
   jetbrains-mono
   noto-fonts-emoji
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

