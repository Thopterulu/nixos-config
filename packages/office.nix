{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian     # Markdown knowledge base / note-taking
    keepassxc    # Offline password manager
    cryptomator  # Cloud storage encryption (vault)
    libreoffice  # Office suite (docs, sheets, slides)
    figma-linux  # UI/UX design tool
    bruno        # API client (Postman alternative)
    bruno-cli    # Bruno headless CLI runner
  ];
}
