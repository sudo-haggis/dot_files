#!/bin/bash

# Create the tmux themes directory if it doesn't exist
mkdir -p ~/.tmux/themes

# Get the current theme from tmux options
CURRENT_THEME=$(tmux show-option -gqv "@theme_mode")

# Default to dark if not set
if [ -z "$CURRENT_THEME" ] || [ "$CURRENT_THEME" != "light" ]; then
    NEW_THEME="light"
else
    NEW_THEME="dark"
fi

# Set the theme option
tmux set-option -g @theme_mode "$NEW_THEME"

# Source the appropriate theme file
tmux source-file ~/.config/tmux/themes/${NEW_THEME}.tmux

# Display message about theme change
tmux display-message "Theme switched to ${NEW_THEME}"
