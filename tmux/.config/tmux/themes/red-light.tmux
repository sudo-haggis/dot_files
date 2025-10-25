# Red Light Theme - Production Environment
# Light background with red accents for alertness

# Pane borders
set -g pane-border-style fg='#f0b8b8'
set -g pane-active-border-style fg='#c9302c'

# Window background
setw -g window-style 'bg=#fcf5f5,fg=#2c3e50'
setw -g window-active-style 'bg=#ffffff,fg='#1a1a1a'

# Status bar - red theme
set -g status-style 'bg=#f5d6d6,fg='#8b1a1a'

# Window status
set -g window-status-format "#[fg=#8b1a1a,bg=#f5d6d6] #I #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#c9302c,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#ffffff,bg=#c9302c,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#c9302c,bold] %H:%M "

# Messages
set -g message-style bg='#c9302c',fg='#ffffff'
set -g message-command-style bg='#c9302c',fg='#ffffff'

# Copy mode
set -g mode-style bg='#f0b8b8',fg='#1a1a1a'

# Clock
set -g clock-mode-colour '#c9302c'
