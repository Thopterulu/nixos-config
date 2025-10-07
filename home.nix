{ config, pkgs, nixvim, ... }:

{
  home.stateVersion = "25.05";
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
    eza      # ls moderne
    bat
    ripgrep
    fd
    htop
    tldr
    google-drive-ocamlfuse
    claude-code
    just
    dbeaver-bin
    postgresql
  ];

  # Service systemd pour monter automatiquement
  systemd.user.services.google-drive = {
    Unit = {
      Description = "Google Drive mount";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "forking";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";
      ExecStart = "${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse %h/GoogleDrive";
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };



  # Qtile config
  home.file = {
    # qtile
    ".config/qtile/config.py".source = ./dotfiles/qtile/config.py;
    # Alacritty config
    ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    # Rofi config 
    ".config/rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
  };

  programs.git = {
    enable = true;
    userName = "thopterulu";
    userEmail = "guillaume.kergueris@gmail.com";
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



  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    opts = {
      autoindent = true;
      smartindent = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      mouse = "a";
    };

    plugins = {
      lualine.enable = true;
      nvim-tree = {
        enable = true;
        openOnSetup = true;
        view.width = 30;
        filters.dotfiles = false;
      };
      web-devicons.enable = true;
      diffview.enable = true;

      treesitter = {
        enable = true;
        nixGrammars = true;

        settings = {
          highlight.enable = true;
          indent.enable = true;  # ← Important pour l'indentation

          # Auto-installation des parsers
          ensure_installed = [
            "bash"
            "c"
            "html"
            "javascript"
            "json"
            "lua"
            "markdown"
            "nix"
            "python"
            "rust"
            "typescript"
            "vim"
            "yaml"
          ];
        };
      };


      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix LSP
          pyright.enable = true;  # Python

        };
      };
      neogit = {
        enable = true;
        settings = {
          integrations = {
            diffview = true;  # Intégration avec diffview
            telescope = true;
          };
          graph_style = "unicode";
          signs = {
            section = [ "" "" ];
            item = [ "" "" ];
          };
        };
      };
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked = { text = "┆"; };
          };
          current_line_blame = true;  # Affiche le blame sur la ligne actuelle
          current_line_blame_opts = {
            delay = 300;
          };
        };
      }; 
      cmp = {
        enable = true;
        autoEnableSources = true;
      };
    };
  };

}
