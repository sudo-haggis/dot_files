# White Light Theme - Neutral/Default Environment
# Light background with minimal gray accents

# Pane borders
set -g pane-border-style fg='#d4d4d4'
set -g pane-active-border-style fg='#666666'

# Window background
setw -g window-style 'bg=#f8f8f8,fg=#2c3e50'
setw -g window-active-style 'bg=#ffffff,fg=#1a1a1a'

# Status bar - minimal gray theme
set -g status-style 'bg=#e8e8e8,fg=#333333'

# Window status
set -g window-status-format "#[fg=#333333,bg=#e8e8e8] #I #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#666666,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#ffffff,bg=#666666,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#666666,bold] %H:%M "

# Messages
set -g message-style bg='#666666',fg='#ffffff'
set -g message-command-style bg='#666666',fg='#ffffff'

# Copy mode
set -g mode-style bg='#d4d4d4',fg='#1a1a1a'

# Clock
set -g clock-mode-colour '#666666'
