{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker-compose # Multi-container Docker orchestration
    vscode         # Visual Studio Code editor
    gcc            # GNU C/C++ compiler
    gnumake        # Build automation tool
    pkg-config     # Library compile/link flag helper
    go             # Go programming language
    uv             # Fast Python package manager
    ruff           # Fast Python linter and formatter
    pre-commit     # Git hooks framework
    dbeaver-bin    # Universal database GUI client
    postgresql     # PostgreSQL client tools (psql)
    mistral-vibe   # Mistral AI client
  ];
}
