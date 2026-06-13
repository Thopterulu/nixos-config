# NixOS Configuration

## Portability: Using Your Packages on Any Linux

This config is portable to any Linux distro (Fedora, Ubuntu, Arch...) via **standalone Home Manager** with Nix.

### How It Works

The flake has three layers:
- `home.nix` — work packages, dotfiles, shell config — **portable to any Linux**
- `home-personal.nix` — personal/gaming/entertainment packages — NixOS only (added on top of `home.nix`)
- `configuration*.nix` — NixOS system services (pipewire, greetd, nvidia, docker daemon...)

| Output | Imports |
|--------|---------|
| `homeConfigurations.thopter` (standalone) | `home.nix` only |
| `nixosConfigurations.thopter-nixos` | `home.nix` + `home-personal.nix` + system configs |
| `nixosConfigurations.thopter-laptop` | `home.nix` + `home-personal.nix` + system configs |

### Setup on a Non-NixOS Linux

1. **Install Nix** (multi-user recommended):
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enable flakes** — add to `~/.config/nix/nix.conf`:
   ```
   experimental-features = nix-command flakes
   ```

3. **Clone this repo**:
   ```bash
   git clone https://github.com/thopterulu/nixos-config.git ~/nixos-config
   ```

4. **Apply the standalone Home Manager config**:
   ```bash
   nix run home-manager -- switch --flake ~/nixos-config#thopter
   ```

   This gives you all work packages and dotfiles from `home.nix` — zsh, neovim, ghostty, git config, fzf, zoxide, GTK theme, devops tools, etc.

### What You Get: Portable vs NixOS Only

| Portable - home.nix (any Linux)  | Personal - home-personal.nix (NixOS) | System - configuration.nix (NixOS) |
|----------------------------------|---------------------------------------|-------------------------------------|
| CLI tools (eza, bat, ripgrep...) | Discord                               | Pipewire / audio stack              |
| Editors (neovim, vscode)         | Gaming (protonup-qt, godot, itch)     | Greetd / display manager            |
| DevOps (kubectl, terraform...)   | DJ / Music (mixxx, scdl)              | NVIDIA drivers                      |
| Apps (libreoffice, obsidian...)  | Media creation (kdenlive, shotcut...) | Docker daemon                       |
| Git, zsh, fzf, zoxide config    | Tor / Tor Browser                     | Bluetooth, smartcard services       |
| Media (vlc, gimp, ffmpeg)        | Personal finance (homebank)           | Steam (NixOS module)                |
| GTK theme, dotfiles, fonts       |                                       | Firewall (opensnitch), AppArmor     |

## DevOps Packages

All DevOps tools are in `home.nix` so they follow you to any machine:

| Package | Description |
|---------|-------------|
| `docker-compose` | Multi-container Docker orchestration |
| `kubectl` | Kubernetes CLI |
| `kubernetes-helm` | Kubernetes package manager |
| `k9s` | TUI for Kubernetes cluster management |
| `terraform` | Infrastructure as Code |
| `ansible` | Configuration management / automation |
| `awscli2` | AWS CLI v2 |
| `google-cloud-sdk` | GCP CLI (gcloud) |
| `lazydocker` | TUI for Docker containers/images |
| `trivy` | Container and filesystem security scanner |
| `vulnix` | CVE scanner for the Nix store (matches derivations against NVD) |

## Security: Scanning for CVEs

`vulnix` walks the Nix store and matches derivation name+version against the NVD CVE database.

Scan the current running system closure:

```bash
vulnix --system
```

Other useful invocations:

```bash
vulnix /run/current-system            # explicit path to the running system
vulnix /nix/var/nix/profiles/system   # the active NixOS profile
vulnix -w whitelist.toml --system     # suppress known/accepted issues
```

For a curated view of nixpkgs-tracked vulnerabilities, see <https://tracker.security.nixos.org/>.

## Project Structure

```
flake.nix                       # Flake entry point (NixOS + standalone HM)
home.nix                        # Dotfiles, shell config, imports work packages (portable)
home-personal.nix               # Imports gaming + entertainment packages (NixOS only)
packages/
  cli.nix                       # CLI tools (eza, bat, ripgrep, tmux...)
  dev.nix                       # Editors & dev tools (neovim, vscode, gcc, go...)
  devops.nix                    # DevOps (kubectl, terraform, ansible, helm...)
  office.nix                    # Office & productivity (obsidian, libreoffice, bruno...)
  desktop.nix                   # Desktop apps (ghostty, rofi, pcmanfm, dunst...)
  media.nix                     # Media (vlc, gimp, ffmpeg)
  audio.nix                     # Audio GUI (pavucontrol, helvum, easyeffects...)
  theming.nix                   # GTK themes & icons
  gaming.nix                    # Gaming (protonup-qt, godot, itch) — personal
  entertainment.nix             # Entertainment (discord, mixxx, tor, kdenlive...) — personal
configs/
  configuration.nix             # Shared NixOS system config
  configuration-desktop.nix     # Desktop: NVIDIA, gaming, performance
  configuration-laptop.nix      # Laptop: touchpad, battery, power mgmt
  nvidia.nix                    # NVIDIA driver config
  hyprland.nix                  # Hyprland compositor
  bluetooth.nix                 # Bluetooth
  smartcard.nix                 # Smart card reader
  firefox.nix                   # Firefox config (home-manager)
  nixvim.nix                    # Neovim config (home-manager)
  monitors.nix                  # Monitor layout
hardware/
  hardware-desktop.nix          # Desktop hardware scan
  laptop.nix                    # Laptop hardware scan
```
