#!/usr/bin/env bash
# Toggle the secondary Dell monitor (HDMI-A-1) on/off.
#
# Why this exists: HDMI-A-1 hangs off the Intel iGPU (card1/i915) while games
# run on the NVIDIA card (card2). Every frame Hyprland renders therefore
# involves compositing a second output on a *different GPU*, with the
# cross-GPU buffer copy that implies. Killing that output while playing
# removes the cost entirely.
#
# NOTE: `hyprctl keyword` does NOT work here — this setup uses the Lua config
# manager, and hyprctl refuses with "keyword can't work with non-legacy
# parsers. Use eval." Hence `hyprctl eval` with hl.monitor().
#
# The enable branch must repeat the geometry from hyprland.lua; there is no
# "restore from config" call. Keep these two in sync.

set -euo pipefail

MON="HDMI-A-1"
MODE="1920x1080@60"
POS="2560x0"
SCALE="1"

# notify-send is not guaranteed to be on PATH depending on how this is invoked,
# and `set -e` turns a missing binary into a silent abort *after* the monitor
# has already been toggled — which strands the display off. Never let the
# notification affect the exit path.
notify() {
    command -v notify-send >/dev/null 2>&1 && notify-send -t 2000 "Display" "$1" || true
}

if hyprctl monitors -j | jq -e --arg m "$MON" 'any(.[]; .name == $m)' >/dev/null; then
    hyprctl eval "hl.monitor({ output = '$MON', disabled = true })" >/dev/null
    notify "$MON disabled (gaming mode)"
else
    # `disabled = false` is REQUIRED and not optional: a monitor rule carrying
    # only geometry does not clear a previously-set disabled flag, so the output
    # silently stays off. Verified the hard way.
    hyprctl eval "hl.monitor({ output = '$MON', mode = '$MODE', position = '$POS', scale = '$SCALE', disabled = false })" >/dev/null
    notify "$MON re-enabled"
fi
