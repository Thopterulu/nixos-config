{ config, lib, pkgs, nixvim, ... }:

{
    imports = [
    nixvim.homeModules.nixvim
    ];

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
        settings = {
          view.width = 30;
          filters.dotfiles = false;
        };
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