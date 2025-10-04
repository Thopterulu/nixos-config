{ config, pkgs, ... }:

{
 home.stateVersion = "25.05";


  home.packages = with pkgs; [
    ripgrep
    fd
    htop
  ];
  
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
