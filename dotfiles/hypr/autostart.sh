#!/usr/bin/env bash

# Google Drive mount
#$HOME/.local/bin/mount-gdrive &

# Stream Controller (Stream Deck software) in background
streamcontroller -b &

# Notification daemon
dunst &

# Discord on workspace 3
hyprctl dispatch exec "[workspace 2] discord" &

# Wait a moment for everything to initialize
sleep 1
