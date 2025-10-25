#!/bin/bash
# Toggle tmux color theme (blue -> red -> yellow -> white)
# Bound to prefix + Tc

# Available color themes
COLORS=("blue" "red" "yellow" "white")

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

# Find current color index
CURRENT_INDEX=-1
for i in "${!COLORS[@]}"; do
    if [ "${COLORS[$i]}" = "$CURRENT_COLOR" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Calculate next color index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#COLORS[@]} ))
NEW_COLOR="${COLORS[$NEXT_INDEX]}"

# Set the new color option
tmux set-option -g @theme_color "$NEW_COLOR"

# Source the appropriate theme file
tmux source-file ~/.config/tmux/themes/${NEW_COLOR}-${CURRENT_CONTRAST}.tmux

# Display message with color indicator
case "$NEW_COLOR" in
    blue)
        EMOJI="🔵"
        ENV="Testing/Dev"
        ;;
    red)
        EMOJI="🔴"
        ENV="Production"
        ;;
    yellow)
        EMOJI="🟡"
        ENV="Staging"
        ;;
    white)
        EMOJI="⚪"
        ENV="Neutral"
        ;;
esac

POSITION=$((NEXT_INDEX + 1))
TOTAL=${#COLORS[@]}
tmux display-message "${EMOJI} Color: ${NEW_COLOR} (${ENV}) • ${CURRENT_CONTRAST} (${POSITION}/${TOTAL})"
