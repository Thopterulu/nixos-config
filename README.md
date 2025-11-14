# NixOS Configuration

## Firejail Security Commands for Gaming

### Basic Firejail Usage
```bash
# Run itch.io client safely
firejail itch

# Run a game with no network access
firejail --net=none ./game-executable

# Run with private home directory (isolated filesystem)
firejail --private=~/game-sandbox ./game-executable

# Maximum security (no network, private filesystem)
firejail --private=~/game-sandbox --net=none ./game-executable
```

### Recommended Game Launch Commands
```bash
# For online games that need network
firejail --private=~/game-sandbox --dns=8.8.8.8 ./online-game

# For single-player games (safest)
firejail --private=~/game-sandbox --net=none --nosound ./offline-game

# For games that need audio
firejail --private=~/game-sandbox --net=none ./game-with-audio

# For debugging (see what firejail is blocking)
firejail --debug --private=~/game-sandbox --net=none ./game
```

### Setup Commands
```bash
# Create sandbox directory
mkdir -p ~/game-sandbox
chmod 700 ~/game-sandbox

# Check firejail profiles
firejail --list

# Test firejail installation
firejail --version
```

### Security Best Practices
- Always use `--private` for isolated filesystem
- Use `--net=none` for offline games
- Monitor processes with `htop` during game execution
- Check file integrity after running games
- Only download games from trusted itch.io developers
