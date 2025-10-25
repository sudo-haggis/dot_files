# Blue Light Theme - Testing/Development Environment
# Light background with blue accents

# Pane borders
set -g pane-border-style fg='#b4c7e7'
set -g pane-active-border-style fg='#4472c4'

# Window background
setw -g window-style 'bg=#f5f8fc,fg=#2c3e50'
setw -g window-active-style 'bg=#ffffff,fg=#1a1a1a'

# Status bar - blue theme
set -g status-style 'bg=#d6e4f5,fg=#1f4788'

# Window status
set -g window-status-format "#[fg=#1f4788,bg=#d6e4f5] #I #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#4472c4,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#ffffff,bg=#4472c4,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#4472c4,bold] %H:%M "

# Messages
set -g message-style bg='#4472c4',fg='#ffffff'
set -g message-command-style bg='#4472c4',fg='#ffffff'

# Copy mode
set -g mode-style bg='#b4c7e7',fg='#1a1a1a'

# Clock
set -g clock-mode-colour '#4472c4'
