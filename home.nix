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
  ];

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
  };

  home.file = {
    "Music/.keep".text = "";
    "Code/.keep".text = "";
    "Notes/.keep".text = "";
    "Documents/.keep".text = "";
    "Downloads/.keep".text = "";
    "Pictures/.keep".text = "";
    "Videos/.keep".text = "";
  };


  programs.git = {
    enable = true;
    userName = "thopterulu";
    userEmail = "guillaume.kergueris@gmail.com";
    extraConfig = {
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



  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      isDefault = true;
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          steam-database
          return-youtube-dislikes
          tree-style-tab
          betterttv
        ];
      };
      settings = {
        "extensions.allowPrivateBrowsingByDefault" = true;
        "extensions.autoDisableScopes" = 0;
        "privacy.clearOnShutdown.extensions-permissions" = false;
        "browser.chrome.site_icons" = true;
        "browser.chrome.favicons" = true;
        "ui.systemUsesDarkTheme" = 1;
        "devtools.theme" = "dark";
        "browser.theme.dark-private-windows" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
      bookmarks = {
        force = true;
        settings = [
        {
          name = "Bookmarks Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "";
              url = "https://soundcloud.com/discover";
            }
            {
              name = "";
              url = "https://www.hltv.org/";
            }
            {
              name = "";
              url = "https://mail.google.com/mail/u/0/?pli=1#inbox";
            }
            {
              name = "";
              url = "https://youtube.com/";
            }
            {
              name = "";
              url = "https://twitch.tv/";
            }
            {
              name = "";
              url = "https://github.com/";
            }
            {
              name = "";
              url = "https://www.mypeopledoc.com/#/login";
            }
            {
              name = "";
              url = "https://www.macifavantages.fr/?at_routeur=nemo&at_obj=promotionnel&at_date_campagne=2025-10-28&at_liste_id=a000126805&at_code_campagne=c000001782&at_univers=macif";
            }
            {
              name = "Nix";
              bookmarks = [
                {
                  name = "NixOS Search - Packages";
                  url = "https://search.nixos.org/packages?channel=unstable&";
                }
                {
                  name = "Nvidia - NixOS Wiki";
                  url = "https://nixos.wiki/wiki/Nvidia";
                }
                {
                  name = "Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher";
                  url = "https://www.nerdfonts.com/cheat-sheet";
                }
              ];
            }
            {
              name = "Find Job";
              bookmarks = [
                {
                  name = "Welcome to the Jungle - Le guide de l'emploi";
                  url = "https://www.welcometothejungle.com/fr";
                }
                {
                  name = "Emplois | Indeed";
                  url = "https://fr.indeed.com/";
                }
                {
                  name = "HelloWork";
                  url = "https://www.hellowork.com/";
                }
              ];
            }
            {
              name = "Certs";
              bookmarks = [
                {
                  name = "Open Source Training | Linux Foundation Training and Certification";
                  url = "https://training.linuxfoundation.org/";
                }
                {
                  name = "THRIVE-ONE ANNUAL e-Learning Subscription - The Linux Foundation";
                  url = "https://trainingportal.linuxfoundation.org/bundles/thrive-one-annual-e-learning-subscription";
                }
                {
                  name = "My Portal";
                  url = "https://trainingportal.linuxfoundation.org/learn/dashboard";
                }
                {
                  name = "CodeCrafters";
                  url = "https://codecrafters.io/";
                }
              ];
            }
            {
              name = "SaaS";
              bookmarks = [
                {
                  name = "Les Gourmets | Trello";
                  url = "https://trello.com/b/pt8yc2Ph/les-gourmets";
                }
                {
                  name = "Grafana Logs Drilldown - Drilldown - Grafana";
                  url = "https://thopter.grafana.net/";
                }
              ];
            }
          ];
        }
        ];
      };
    };
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
      supermaven.enable = true;
      ccc = {
        enable = true;
        settings = {
          highlighter = {
            auto_enable = true;
            lsp = true;
          };
        };
      };


      nvim-tree = {
        enable = true;
        openOnSetup = true;
        view.width = 30;
        filters.dotfiles = false;
      };
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true;  # treesitter
          fast_warp = {}; # will fast wrap with alt + e
        };
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
            "go"
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
          gopls.enable = true;  # golang
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
