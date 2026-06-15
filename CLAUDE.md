# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal NixOS + Home Manager configuration, distributed as a single flake. Targets two physical machines (a gaming desktop with Nvidia, a laptop without) and is also usable on any non-NixOS Linux through standalone Home Manager. All inputs (nixpkgs, home-manager, nixvim) track the `nixos-25.11` / `release-25.11` branches.

## The three-layer split (load-bearing)

This is the architectural decision that drives everything; understand it before editing.

| Layer | File | Output | Audience |
|---|---|---|---|
| Portable | `home.nix` | `homeConfigurations.thopter` | **Any Linux** with Nix installed |
| Personal | `home-personal.nix` (imports `home.nix`) | folded into both NixOS configs | NixOS only |
| System | `configs/configuration*.nix` | `nixosConfigurations.thopter-{nixos,laptop}` | NixOS only |

- `home.nix` MUST stay portable — anything that requires the NixOS module system (services, hardware, kernel, system packages) belongs in `configs/`, not here. Adding a NixOS-only option to `home.nix` breaks the `homeConfigurations.thopter` output.
- `home-personal.nix` is the "gaming + entertainment" tier (Discord, Steam-adjacent tools, kdenlive, Tor…). Both `nixosConfigurations` pull it in via the home-manager module wired up in `flake.nix`.
- `configs/configuration.nix` is the shared NixOS base. `configuration-desktop.nix` and `configuration-laptop.nix` import it and add hardware-specific bits.

Package lists live under `packages/` and are imported by the appropriate home file — they're plain home-manager modules, not standalone derivations.

## Common commands

```bash
# Rebuild the running NixOS system (pick the right host)
sudo nixos-rebuild switch --flake .#thopter-nixos     # desktop
sudo nixos-rebuild switch --flake .#thopter-laptop    # laptop

# Standalone Home Manager (non-NixOS Linux, or just home layer)
nix run home-manager -- switch --flake .#thopter

# Validate the flake without building (cheap evaluation check)
nix flake check --no-build

# Update inputs (nixpkgs/home-manager/nixvim/nur)
nix flake update

# CVE scan of the running system closure
vulnix --system
```

When adding a new `.nix` file, **`git add` it (even as `--intent-to-add`) before evaluating**. Flakes read from the git tree, and `nix flake check` / rebuild will error with "path does not exist" on untracked files.

## Hardening interaction (gaming desktop)

`configs/configuration-desktop.nix` sets `boot.kernelParams = [ "mitigations=off" ... ]` deliberately to recover gaming perf — this is a conscious Spectre/MDS-vs-FPS tradeoff. As a consequence:

- **Do not add CPU-side mitigation `kernelParams`** (`spectre_v2=on`, `pti=on`, `mds=…`, `l1tf=…`) — they are silently overridden.
- Hardening that *does* take effect lives in `configs/hardening.nix`: sysctls (R9/R12/R14 from the ANSSI Linux guide), plus `slab_nomerge`, `page_alloc.shuffle=1`, `iommu=pt`, `intel_iommu=on`. Imported from `configuration.nix`, so it applies to both desktop and laptop.
- See the "Security: System Hardening" section in `README.md` for the full list of what was intentionally skipped to keep Steam/Proton, Nvidia, controllers, and VR working.

## Other things worth knowing

- **Terminal is `ghostty`** (window class `com.mitchellh.ghostty`). `kitty` was removed; the waybar temperature widget and Hyprland's `swallow_regex` reference ghostty now.
- **Hyprland** is the compositor; greetd + tuigreet is the display manager. X11 is kept enabled only for XWayland.
- **Locale and keyboard are French**: `fr_FR.UTF-8`, `xkb.layout = "fr"`, `caps:escape`.
- **AppArmor + OpenSnitch** are already enabled in `configuration.nix`. Docker (with `docker_29`) is also a system service.
- **Laptop overrides** in `configuration-laptop.nix` use `lib.mkForce` to strip Nvidia entirely and swap the `extraGroups` list — preserve this pattern when adding user-group changes.
- **Dotfiles under `dotfiles/`** are deployed via `home.file` in `home.nix`. Hyprland's main config is symlinked file-by-file (not the whole directory) so that `nwg-displays` can write `monitors.conf` next to it.
