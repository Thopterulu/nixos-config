#!/usr/bin/env bash
# Waybar helper: report whether a hyprshell surface (overview / launcher /
# switch) is currently grabbing input.
#
# Why this exists: hyprshell opens gtk4-layer-shell surfaces that grab the
# keyboard. When one is open (or wedged) the mouse still works on windows but
# keystrokes never reach your programs -> it feels like you are "stuck".
# This module makes that state visible in the bar, and clicking it restarts
# hyprshell (same as SUPER+SHIFT+R) to break out.
#
# Output: single line of JSON for a waybar custom module (return-type json).

set -euo pipefail

# Any layer-shell namespace containing "hyprshell" means an overlay is up.
if hyprctl layers -j 2>/dev/null | jq -e '
      [.. | .namespace? // empty]
      | any(ascii_downcase | contains("hyprshell"))
    ' >/dev/null 2>&1; then
  # Overview / launcher is open and holding keyboard focus.
  printf '{"text":"","alt":"open","class":"open","tooltip":"hyprshell overlay is OPEN and grabbing the keyboard\\nClick to restart hyprshell (SUPER+SHIFT+R)"}\n'
else
  # Normal tiling mode: input goes to your programs.
  printf '{"text":"","alt":"normal","class":"normal","tooltip":"Normal mode - keyboard goes to windows\\nClick to restart hyprshell"}\n'
fi
