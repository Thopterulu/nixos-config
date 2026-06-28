# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix
    ./hardening.nix
    ./hyprland.nix
    ./smartcard.nix
  ];

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

  # Explicit deny-by-default firewall. Default is already enabled; restated here
  # so it's a deliberate choice and individual modules opt in via openFirewall.
  networking.firewall.enable = true;

  # Enable WiFi firmware
  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  # LC_* categories — without these, only LANG is French; numbers, currency,
  # dates etc. fall back to C/POSIX and apps render mixed formatting.
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT    = "fr_FR.UTF-8";
    LC_MONETARY       = "fr_FR.UTF-8";
    LC_NAME           = "fr_FR.UTF-8";
    LC_NUMERIC        = "fr_FR.UTF-8";
    LC_PAPER          = "fr_FR.UTF-8";
    LC_TELEPHONE      = "fr_FR.UTF-8";
    LC_TIME           = "fr_FR.UTF-8";
  };
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "fr";
  #  useXkbConfig = true; # use xkb.options in tty.
  # };


  # greetd display manager with tuigreet (TUI greeter)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Auto-login to user session after first boot (optional, comment out if not wanted)
  # services.greetd.settings.initial_session = {
  #   command = "Hyprland";
  #   user = "thopter";
  # };

  # X11 support (kept minimal for XWayland compatibility)
  services.xserver = {
    enable = true;  # Still needed for XWayland and some apps
    xkb.layout = "fr";
    xkb.model = "pc105";
    xkb.options = "caps:escape";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
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
    # wireplumber.extraScripts = {
    #   "force-nova-pro-analog.lua" = ''
    #     -- Force analog profile for SteelSeries Arctis Nova Pro Wireless
    #     -- IEC958 (digital SPDIF) doesn't work, use analog instead

    #     -- Function to set profile on matching card
    #     local function set_nova_pro_analog(card)
    #       if card["node.name"] == "alsa_card.usb-SteelSeries_Arctis_Nova_Pro_Wireless-00" then
    #         wp_set_property(card, "api.alsa.profile", "output:analog-stereo+input:mono-fallback")
    #       end
    #     end

    #     -- Monitor for new cards
    #     wp_observe_property(ctx, "card", function(card)
    #       set_nova_pro_analog(card)
    #     end)

    #     -- Also check existing cards on startup
    #     for _, card in ipairs(wp_get_objects(ctx, { type = "card" })) do
    #       set_nova_pro_analog(card)
    #     end
    #   '';
    # };
  };

  # Ensure PulseAudio compatibility for applications
  services.pulseaudio.enable = false;  # Explicitly disable to avoid conflicts

  # Pour le gaming
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.thopter = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "input" "realtime" ]; # Enable 'sudo' for the user + realtime audio
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.fuse.userAllowOther = true;
  programs.i3lock.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  # nix-index-database wires up `nix-index` + `comma` and sets
  # programs.command-not-found.enable = false by default (mkDefault).
  programs.nix-index-database.comma.enable = true;
  services.dbus.enable = true;

  # Allow users in wheel and audio groups to use realtime scheduling
  security.polkit.extraConfig = lib.mkAfter ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.RealtimeKit1.acquire-high-priority" ||
           action.id == "org.freedesktop.RealtimeKit1.acquire-real-time") &&
          (subject.isInGroup("wheel") || subject.isInGroup("audio"))) {
        return polkit.Result.YES;
      }
    });
  '';
  # Controller support
  # hardware.xone.enable = true;  # Xbox One controller USB support - disabled to avoid Bluetooth conflicts

  # Steam controller support
  hardware.steam-hardware.enable = true;

  # Enable OpenSnitch application firewall
  services.opensnitch.enable = true;

  # Periodic SSD TRIM (weekly fstrim timer)
  services.fstrim.enable = true;

  # LVFS firmware updates (`fwupdmgr refresh && fwupdmgr update`)
  services.fwupd.enable = true;

  # SMART disk-health monitoring; logs to journald, autodetects drives
  services.smartd.enable = true;

  # OOM protection — kill the worst slice before the kernel locks the box up.
  # System slice covers misbehaving services; user slice covers user-session runaways.
  systemd.oomd = {
    enable = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  # RAM compression as virtual swap. With vm.swappiness=1 the kernel barely
  # touches it, but when it does, compressing in RAM beats hitting the SSD.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Cap journald so logs don't quietly fill /var. 1G is plenty for postmortems
  # without becoming a multi-GB blackhole.
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    SystemMaxFileSize=128M
  '';

  # Build mandb index so `man -k <kw>`, `apropos`, and tldr lookups work.
  documentation.man.cache.enable = true;

  # Syncthing file synchronisation (LAN sync + discovery, GUI on 127.0.0.1:8384)
  services.syncthing = {
    enable = true;
    user = "thopter";
    group = "users";
    dataDir = "/home/thopter";
    configDir = "/home/thopter/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
  };

  # Enable AppArmor security framework
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };
  # Enable Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    refind
    ntfs3g
    pciutils
    pulseaudio        # pactl CLI
    smartmontools     # smartctl — pairs with services.smartd
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;
  # Lets thopter use --option overrides and push to remote stores.
  nix.settings.trusted-users = [ "thopter" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Binary caches — nix-community covers nixvim, home-manager add-ons, lots of
  # community packages. cache.nixos.org is added by default; listed for clarity.
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  boot.tmp.cleanOnBoot = true;
  system.stateVersion = "25.11"; # Did you read the comment?

}

