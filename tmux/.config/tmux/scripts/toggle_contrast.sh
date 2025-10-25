#!/bin/bash
# Toggle tmux contrast (light <-> dark)
# Bound to prefix + Tt

# Get current theme settings
CURRENT_COLOR=$(tmux show-option -gqv "@theme_color")
CURRENT_CONTRAST=$(tmux show-option -gqv "@theme_contrast")

# Default to blue if not set
if [ -z "$CURRENT_COLOR" ]; then
    CURRENT_COLOR="blue"
fi

# Default to dark if not set
if [ -z "$CURRENT_CONTRAST" ]; then
    CURRENT_CONTRAST="dark"
fi

# Toggle contrast
if [ "$CURRENT_CONTRAST" = "light" ]; then
    NEW_CONTRAST="dark"
else
    NEW_CONTRAST="light"
fi

# Set the new contrast option
tmux set-option -g @theme_contrast "$NEW_CONTRAST"

# Source the appropriate theme file
tmux source-file ~/.config/tmux/themes/${CURRENT_COLOR}-${NEW_CONTRAST}.tmux

# Display message with contrast indicator
if [ "$NEW_CONTRAST" = "light" ]; then
    EMOJI="☀️"
else
    EMOJI="🌙"
fi

tmux display-message "${EMOJI} Contrast: ${NEW_CONTRAST} • Color: ${CURRENT_COLOR}"
