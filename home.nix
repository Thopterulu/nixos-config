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
  }
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
   

    plugins = with pkgs.vimPlugins; [
      nvchad
      nvchad-ui
      plenary-nvim
      nvim-web-devicons
    ]; 
  };
  
  programs.git = {
    enable = true;
    userName = "thopterulu";
    userEmail = "guillaume.kergueris@gmail.com";
  };
}
