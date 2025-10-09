{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python package manager
    uv
    
    # Docker for containerization
    docker
    docker-compose
    
    # Pre-commit hooks
    pre-commit
    
    # Common development tools
    git
  ];

  shellHook = ''
    echo "Development environment loaded!"
    echo "Available tools:"
    echo "  - uv (Python package manager)"
    echo "  - docker & docker-compose"
    echo "  - pre-commit"
    echo ""
    echo "To get started:"
    echo "  - Run 'pre-commit install' to set up git hooks"
    echo "  - Use 'uv' for Python package management"
    echo "  - Use 'docker' for containerization"
  '';
}