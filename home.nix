{ config, pkgs, ... }:

{
 home.stateVersion = "25.05";


  home.packages = with pkgs; [
    ripgrep
    fd
    htop
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
      # lsp = {
      #   enable = true;
      #   servers = {
      #     nil_ls.enable = true; # Nix LSP
      #     pyright.enable = true;  # Python
      #   };
      # };
      
      cmp = {
        enable = true;
        autoEnableSources = true;
      };
    };
  };

}
