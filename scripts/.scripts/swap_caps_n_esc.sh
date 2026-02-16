#!/bin/bash

# caps-espace.sh Map caps lock to Escape
#

if command -v gsettings &>/dev/null; then
    #GNOME - use Gsettings
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
    echo "Caps mapped to Esc via GNOME"
elif [ -n "$DISPLAY" ]; then
    # X11 - use set xkbmap
    setxkbmap -option caps:escpae
    echo "Caps mapped to Esc via X11"
else
    echo "No display session to call"
    exit 1
fi
