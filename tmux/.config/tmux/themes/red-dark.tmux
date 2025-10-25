# Red Dark Theme - Production Environment
# Dark background with red accents for alertness

# Pane borders
set -g pane-border-style fg='#5a3030'
set -g pane-active-border-style fg='#ff5252'

# Window background
setw -g window-style 'bg=#2a1e1e,fg='#e0c8c8'
setw -g window-active-style 'bg=#3a2626,fg='#f5e8e8'

# Status bar - red theme
set -g status-style 'bg='#3e2c2c',fg='#ffb8b8'

# Window status
set -g window-status-format "#[fg=#ffb8b8,bg=#3e2c2c] #I #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#ff5252,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#ffffff,bg=#ff5252,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#ff5252,bold] %H:%M "

# Messages
set -g message-style bg='#ff5252',fg='#1a1a1a'
set -g message-command-style bg='#ff5252',fg='#1a1a1a'

# Copy mode
set -g mode-style bg='#5a3030',fg='#ffffff'

# Clock
set -g clock-mode-colour '#ff5252'
