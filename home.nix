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
    protonup-qt    # Manage custom Proton versions
    i3lock-fancy   # Screen lock (fallback for hyprlock)
    libreoffice
    opensnitch-ui
    bubblewrap
    insomnia
    figma-linux
    itch
  ];

  services.hyprshell = {
    enable = true;
    settings = {
      windows = {
        scale = 8.0;
        overview = {
          launcher = {
            max_items = 6;
          };
        };
        switch = {
          modifier = "alt";
        };
      };
    };
  };


  # All home.file configurations merged into one block
  home.file = {
    # Auto-mount Google Drive script
    ".local/bin/mount-gdrive" = {
      source = ./scripts/mount-gdrive.sh;
      executable = true;
    };

    # dotfiles config - link each subdirectory individually
    ".config/alacritty".source = ./dotfiles/alacritty;
    ".config/dunst".source = ./dotfiles/dunst;
    ".config/flameshot".source = ./dotfiles/flameshot;
    ".config/hypr".source = ./dotfiles/hypr;
    ".config/pcmanfm".source = ./dotfiles/pcmanfm;
    ".config/rofi".source = ./dotfiles/rofi;
    ".config/waybar".source = ./dotfiles/waybar;

    # Directory structure
    "Music/.keep".text = "";
    "Code/.keep".text = "";
    "Notes/.keep".text = "";
    "Documents/.keep".text = "";
    "Downloads/.keep".text = "";
    "Pictures/.keep".text = "";
    "Pictures/Screenshots/.keep".text = "";
    "Videos/.keep".text = "";
    "game-sandbox/.keep".text = "";
  };

  # Enable GTK
  gtk.enable = true;


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
