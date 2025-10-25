# White Dark Theme - Neutral/Default Environment
# Dark background with minimal gray accents

# Pane borders
set -g pane-border-style fg='#3a3a3a'
set -g pane-active-border-style fg='#a8a8a8'

# Window background
setw -g window-style 'bg=#1e1e1e,fg=#d4d4d4'
setw -g window-active-style 'bg=#252525,fg=#e8e8e8'

# Status bar - minimal gray theme
set -g status-style 'bg=#2c2c2c',fg='#cccccc'

# Window status
set -g window-status-format "#[fg=#cccccc,bg=#2c2c2c] #I #W "
set -g window-status-current-format "#[fg=#1a1a1a,bg=#a8a8a8,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#1a1a1a,bg=#a8a8a8,bold] #S "
set -g status-right "#[fg=#1a1a1a,bg=#a8a8a8,bold] %H:%M "

# Messages
set -g message-style bg='#a8a8a8',fg='#1a1a1a'
set -g message-command-style bg='#a8a8a8',fg='#1a1a1a'

# Copy mode
set -g mode-style bg='#3a3a3a',fg='#ffffff'

# Clock
set -g clock-mode-colour '#a8a8a8'
