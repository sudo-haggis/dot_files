#!/bin/bash

# Create the tmux themes directory if it doesn't exist
mkdir -p ~/.tmux/themes

# Define available themes (NO COMMAS in bash arrays!)
THEMES=("light" "medium" "dark")

# Get the current theme from tmux options
CURRENT_THEME=$(tmux show-option -gqv "@theme_mode")

# Find current theme index (NO SPACE around =)
CURRENT_INDEX=-1
for i in "${!THEMES[@]}"; do
    if [ "${THEMES[$i]}" = "$CURRENT_THEME" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Calculate next theme index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#THEMES[@]} ))
NEW_THEME="${THEMES[$NEXT_INDEX]}"

# Set the theme option
tmux set-option -g @theme_mode "$NEW_THEME"

# Update environment for all sessions
tmux set-environment THEME_MODE "$NEW_THEME"

# Source the appropriate theme file  
tmux source-file ~/.config/tmux/themes/${NEW_THEME}.tmux

# Give tmux time to update environment
sleep 0.2

# Display message with correct syntax
POSITION=$((NEXT_INDEX + 1))
TOTAL=${#THEMES[@]}
tmux display-message "🎨 Theme: ${NEW_THEME} (${POSITION}/${TOTAL}) • Press T to cycle"
