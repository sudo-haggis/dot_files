# Yellow Light Theme - Staging/Warning Environment
# Light background with yellow/amber accents

# Pane borders
set -g pane-border-style fg='#f0e0b8'
set -g pane-active-border-style fg='#d68910'

# Window background
setw -g window-style 'bg=#fcf9f5,fg='#2c3e50'
setw -g window-active-style 'bg=#ffffff,fg='#1a1a1a'

# Status bar - yellow theme
set -g status-style 'bg=#f5ead6,fg='#7a5c00'

# Window status
set -g window-status-format "#[fg=#7a5c00,bg=#f5ead6] #I #W "
set -g window-status-current-format "#[fg=#1a1a1a,bg=#d68910,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#1a1a1a,bg=#d68910,bold] #S "
set -g status-right "#[fg=#1a1a1a,bg=#d68910,bold] %H:%M "

# Messages
set -g message-style bg='#d68910',fg='#1a1a1a'
set -g message-command-style bg='#d68910',fg='#1a1a1a'

# Copy mode
set -g mode-style bg='#f0e0b8',fg='#1a1a1a'

# Clock
set -g clock-mode-colour '#d68910'
