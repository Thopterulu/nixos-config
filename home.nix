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
  ];


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
      plugins = [ 
        "git" 
        "sudo" 
        "docker" 
        "kubectl"
        "rust"
        "npm"
      ];
      theme = "robbyrussell";
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

  # Starship - prompt moderne
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$cmd_duration $character";

      # Username
    
      username = {
        show_always = true;
        style_user = "bold green";
        style_root = "bold red";
        format = "[$user]($style)";
      };
      
      # Hostname
      hostname = {
        ssh_only = false;  # Toujours afficher
        style = "bold green";
        format = "[@$hostname]($style):";
      };
      
      # Directory
      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)";
      };
      
      # Git branch
      git_branch = {
        symbol = "";
        style = "bold purple";
        format = " on [$symbol$branch]($style)";
      };
      
      # Git status
      git_status = {
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
        style = "bold red";
        format = "[$all_status$ahead_behind]($style)";
      };
      
      # Temps d'exécution
      cmd_duration = {
        min_time = 500;
        format = "took [$duration](bold yellow)";
        show_milliseconds = false;
      };
      
      # Pas d'heure (pour garder compact)
      time.disabled = true;
      
      # Character (flèche)
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
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
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      mouse = "a";
    };
    
    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      nvim-tree.enable = true;
      web-devicons.enable = true;
      
       lsp = {
         enable = true;
         servers = {
           nil_ls.enable = true; # Nix LSP
           pyright.enable = true;  # Python

         };
       };
      
      cmp = {
        enable = true;
        autoEnableSources = true;
      };
    };
  };

}
