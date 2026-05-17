{ pkgs, ... }:

{
  home.packages = with pkgs; [
    protonup-qt # Manage custom Proton/Wine versions for Steam
    godot       # 2D/3D game engine
    itch        # itch.io desktop client
  ];

  home.file = {
    "game-sandbox/.keep".text = "";
  };
}
