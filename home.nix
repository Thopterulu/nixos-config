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
    direnv
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

    # Monitor management scripts
    ".local/bin/toggle-monitor" = {
      source = ./scripts/toggle-monitor.sh;
      executable = true;
    };
    ".local/bin/enable-monitor" = {
      source = ./scripts/enable-monitor.sh;
      executable = true;
    };

    # smart card protocol handler
    ".local/share/applications/xscp-smartcard.desktop" = {
      source = ./files/xscp-smartcard.desktop;
    };

    # dotfiles config - link each subdirectory individually
    ".config/alacritty".source = ./dotfiles/alacritty;
    ".config/dunst".source = ./dotfiles/dunst;
    ".config/flameshot".source = ./dotfiles/flameshot;
    # Hypr config - link files individually to allow nwg-displays to write monitors.conf
    ".config/hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;
    ".config/hypr/hypridle.conf".source = ./dotfiles/hypr/hypridle.conf;
    ".config/hypr/autostart.sh" = {
      source = ./dotfiles/hypr/autostart.sh;
      executable = true;
    };
    ".config/hypr/scripts".source = ./dotfiles/hypr/scripts;
    ".config/pcmanfm".source = ./dotfiles/pcmanfm;
    ".config/rofi".source = ./dotfiles/rofi;
    ".config/swappy".source = ./dotfiles/swappy;
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
    "backgrounds/.keep".text = "";
    "game-sandbox/.keep".text = "";
  };

  # Enable GTK with dark theme
  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
      # Alternative: Qogir theme (uncomment to use)
      # name = "Qogir-Dark";
      # package = pkgs.qogir-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
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
      #if [ ! -d "$HOME/GoogleDrive" ] || ! mountpoint -q "$HOME/GoogleDrive" 2>/dev/null; then
      #  "$HOME/.local/bin/mount-gdrive" 2>/dev/null &
      #fi
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

  # MIME type associations (default applications)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Images → GIMP
      "image/png" = "gimp.desktop";
      "image/jpeg" = "gimp.desktop";
      "image/jpg" = "gimp.desktop";
      "image/gif" = "gimp.desktop";
      "image/bmp" = "gimp.desktop";
      "image/webp" = "gimp.desktop";
      "image/tiff" = "gimp.desktop";
      "image/svg+xml" = "gimp.desktop";

      # Videos → VLC
      "video/mp4" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";  # MKV
      "video/webm" = "vlc.desktop";
      "video/avi" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";  # MOV
      "video/x-flv" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";

      # Audio → VLC
      "audio/mpeg" = "vlc.desktop";  # MP3
      "audio/mp4" = "vlc.desktop";   # M4A
      "audio/flac" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/x-vorbis+ogg" = "vlc.desktop";
      "audio/aac" = "vlc.desktop";

      # PDFs → Firefox
      "application/pdf" = "firefox.desktop";

      # Web browser → Firefox
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      # Office documents → LibreOffice
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
      "application/msword" = "libreoffice-writer.desktop";

      # smart card protocol handlers
      "x-scheme-handler/xscpsmartcard" = "xscp-smartcard.desktop";
      "x-scheme-handler/smartcard" = "xscp-smartcard.desktop";
    };
  };

}
