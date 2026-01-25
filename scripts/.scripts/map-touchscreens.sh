#!/bin/bash
# Map touchscreens to correct displays
# Only runs if both Zen Touch and external display are connected

# Check if Zen Touch exists
if ! xinput list | grep -q "eGalaxTouch"; then
    exit 0  # Silent exit, no Zen Touch connected
fi

# Check if DVI display is connected
if ! xrandr | grep -q "DVI-I-1-1 connected"; then
    exit 0  # Silent exit, external display not connected
fi

# Both exist, do the mapping
xinput map-to-output 9 eDP-1 2>/dev/null           # Pavilion touch to Pavilion screen
xinput map-to-output 17 DVI-I-1-1 2>/dev/null      # Zen Touch to Zen screen
