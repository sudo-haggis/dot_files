# Blue Dark Theme - Testing/Development Environment
# Dark background with blue accents

# Pane borders
set -g pane-border-style fg='#3d5a80'
set -g pane-active-border-style fg='#5e9eff'

# Window background
setw -g window-style 'bg=#1e2a3a,fg=#c8d3e0'
setw -g window-active-style 'bg=#263447,fg=#e8eef5'

# Status bar - blue theme
set -g status-style 'bg=#2c3e50,fg='#a8c5e8'

# Window status
set -g window-status-format "#[fg=#a8c5e8,bg=#2c3e50] #I #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#5e9eff,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#ffffff,bg=#5e9eff,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#5e9eff,bold] %H:%M "

# Messages
set -g message-style bg='#5e9eff',fg='#1a1a1a'
set -g message-command-style bg='#5e9eff',fg='#1a1a1a'

# Copy mode
set -g mode-style bg='#3d5a80',fg='#ffffff'

# Clock
set -g clock-mode-colour '#5e9eff'
