#!/usr/bin/env bash
# Toggle the secondary Dell monitor (HDMI-A-4) on/off.
#
# Why this exists: HISTORICALLY the Dell hung off the Intel iGPU (card1/i915)
# while games ran on the NVIDIA card (card2), so compositing it cost a
# cross-GPU buffer copy every frame. That is NO LONGER TRUE — both outputs now
# hang off the NVIDIA card (card2: DP-4 = Samsung, HDMI-A-4 = Dell) and every
# card1 connector reads "disconnected". The cross-GPU cost is gone.
#
# What remains is ordinary: one fewer 1920x1080 output to composite, and no
# second screen to pull focus. Worth a keybind, not worth treating as a
# prerequisite for smooth gameplay the way it used to be. Direct scanout on
# DP-4 is evaluated per-monitor and does not care whether this one is on.
#
# NOTE: `hyprctl keyword` does NOT work here — this setup uses the Lua config
# manager, and hyprctl refuses with "keyword can't work with non-legacy
# parsers. Use eval." Hence `hyprctl eval` with hl.monitor().
#
# The enable branch must repeat the geometry from hyprland.lua; there is no
# "restore from config" call. Keep these two in sync.

set -euo pipefail

# Connector name, NOT the description. This changed from HDMI-A-1 to HDMI-A-4
# when the Dell moved off the iGPU onto the NVIDIA card — connector names are
# per-card, so re-cabling renames them. The old value made this script a silent
# no-op: the `any(.name == $m)` test never matched, so it always took the
# enable branch and tried to configure a connector that does not exist.
MON="HDMI-A-4"
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
