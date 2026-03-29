#!/usr/bin/env bash

# Get player status
status=$(playerctl status 2>/dev/null)

if [ -z "$status" ]; then
    echo '{"text":"", "tooltip":"No media playing", "class":"stopped"}'
    exit 0
fi

# Get metadata
artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
player=$(playerctl -l 2>/dev/null | head -1)

# Truncate long strings
max_len=40
if [ ${#artist} -gt 0 ] && [ ${#title} -gt 0 ]; then
    combined="${artist} - ${title}"
else
    combined="${title:-No title}"
fi

if [ ${#combined} -gt $max_len ]; then
    display="${combined:0:$max_len}..."
else
    display="$combined"
fi

# Set icon based on status
if [ "$status" = "Playing" ]; then
    icon="▶"
    class="playing"
elif [ "$status" = "Paused" ]; then
    icon="⏸"
    class="paused"
else
    icon="⏹"
    class="stopped"
fi

# Get player icon
case "$player" in
    *spotify*)
        player_icon=""
        ;;
    *firefox*)
        player_icon="🎧"
        ;;
    *mpv*)
        player_icon="🎵"
        ;;
    *vlc*)
        player_icon="🎵"
        ;;
    *)
        player_icon="♪"
        ;;
esac

# Output JSON
tooltip="Player: ${player}\nArtist: ${artist}\nTitle: ${title}\nStatus: ${status}"
echo "{\"text\":\"${player_icon} ${icon} ${display}\", \"tooltip\":\"${tooltip}\", \"class\":\"${class}\"}"
