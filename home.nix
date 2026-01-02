{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";
  imports = [
    ./configs/firefox.nix
    ./configs/nixvim.nix
  ];

  home.packages = with pkgs; [
    eza      # ls moderne
    bat
    ripgrep
    fd
    htop
    tldr
    rclone
    claude-code
    just
    dbeaver-bin
    postgresql
    pre-commit
    docker
    docker-compose
    uv
    obsidian
    go
    mixxx
    scdl
    ffmpeg
    rfc
    tor
    tor-browser
    xorg.xkill
    protonup-qt    # Manage custom Proton versions
    i3lock-fancy   # Uses current screen as blurred background
    libreoffice
    opensnitch-ui
    bubblewrap
    insomnia
    figma-linux
    itch
  ];

  # Auto-lock screen with xidlehook
  services.xidlehook = {
    enable = true;
    detect-sleep = true;
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      {
        delay = 330;  # 330 seconds - turn screens off
        command = "${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | tail -n +2 | awk '{print $NF}' | xargs -I {} ${pkgs.xorg.xrandr}/bin/xrandr --output {} --brightness 0";
        canceller = "${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | tail -n +2 | awk '{print $NF}' | xargs -I {} ${pkgs.xorg.xrandr}/bin/xrandr --output {} --brightness 1";
      }
      {
        delay = 300;  # 5 minutes - lock screen
        command = "i3lock-fancy";
      }
      {
        delay = 900;  # 15 minutes - suspend system
        command = "systemctl suspend";
      }
    ];
  };

  # Auto-mount Google Drive script
  home.file.".local/bin/mount-gdrive" = {
    source = ./scripts/mount-gdrive.sh;
    executable = true;
  };



  # Qtile config
  home.file = {
    # qtile
    ".config/qtile/config.py".source = ./dotfiles/qtile/config.py;
    ".config/qtile/background.py".source = ./dotfiles/qtile/background.py;
    # Alacritty config
    ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    # Rofi config
    ".config/rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
    ".config/rofi/tokyo-night.rasi".source = ./dotfiles/rofi/tokyo-night.rasi;
    # PCManFM config
    ".config/pcmanfm/default/pcmanfm.conf".source = ./dotfiles/pcmanfm/pcmanfm.conf;
    # Autorandr profiles
    ".config/autorandr/desktop/config".source = ./dotfiles/autorandr/desktop/config;
    ".config/autorandr/projector/config".source = ./dotfiles/autorandr/projector/config;
    ".config/hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
    # Waybar config
    #".config/waybar/config.jsonc".source = ./dotfiles/waybar/config.jsonc;
    #".config/waybar/style.css".source = ./dotfiles/waybar/style.css;
  };

  # Enable GTK
  gtk.enable = true;

  home.file = {
    "Music/.keep".text = "";
    "Code/.keep".text = "";
    "Notes/.keep".text = "";
    "Documents/.keep".text = "";
    "Downloads/.keep".text = "";
    "Pictures/.keep".text = "";
    "Videos/.keep".text = "";
    "game-sandbox/.keep".text = "";
  };


  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "thopterulu";
        email = "guillaume.kergueris@gmail.com";
      };
      pull = {
        rebase = true;
        ff = "only";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "npm"
        "colored-man-pages"
      ];
    };

    shellAliases = {
      ll = "eza -la";
      ls = "eza";
      cat = "bat";
      cd = "z";
    };

    # Init scripts
    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Auto-mount Google Drive on shell startup
      if [ ! -d "$HOME/GoogleDrive" ] || ! mountpoint -q "$HOME/GoogleDrive" 2>/dev/null; then
        "$HOME/.local/bin/mount-gdrive" 2>/dev/null &
      fi
    '';
  };

  # FZF - recherche floue (Ctrl+R pour historique)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide - cd intelligent
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };


}
