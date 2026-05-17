{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eza            # Modern ls replacement
    bat            # Cat with syntax highlighting
    ripgrep        # Fast recursive grep
    fd             # Fast find alternative
    htop           # Interactive process viewer
    btop           # Resource monitor (CPU, RAM, disk, network)
    tldr           # Simplified man pages with examples
    wget           # File downloader
    git            # Version control
    xclip          # Clipboard manager for X11
    zip            # Archive compressor
    unzip          # Archive extractor
    psmisc         # Process utilities (killall, fuser, pstree)
    tmux           # Terminal multiplexer
    neofetch       # System info display
    playerctl      # Media player controller (play/pause/next)
    delta          # Git diff viewer with syntax highlighting
    direnv         # Auto-load env vars per directory
    rclone         # Cloud storage sync (Google Drive, S3...)
    claude-code    # Anthropic CLI assistant
    just           # Command runner (Makefile alternative)
    rfc            # RFC document reader
    openssl        # Cryptography toolkit
  ];
}
