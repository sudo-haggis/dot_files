# Yellow Dark Theme - Staging/Warning Environment
# Dark background with yellow/amber accents

# Pane borders
set -g pane-border-style fg='#5a4f30'
set -g pane-active-border-style fg='#ffb627'

# Window background
setw -g window-style 'bg=#2a251e,fg='#e0d8c8'
setw -g window-active-style 'bg=#352f26,fg='#f5ede8'

# Status bar - yellow theme
set -g status-style 'bg='#3e3a2c',fg='#ffd68f'

# Window status
set -g window-status-format "#[fg=#ffd68f,bg=#3e3a2c] #I #W "
set -g window-status-current-format "#[fg=#1a1a1a,bg=#ffb627,bold] #I #W "

# Status bar elements
set -g status-left "#[fg=#1a1a1a,bg=#ffb627,bold] #S "
set -g status-right "#[fg=#1a1a1a,bg=#ffb627,bold] %H:%M "

# Messages
set -g message-style bg='#ffb627',fg='#1a1a1a'
set -g message-command-style bg='#ffb627',fg='#1a1a1a'

# Copy mode
set -g mode-style bg='#5a4f30',fg='#ffffff'

# Clock
set -g clock-mode-colour '#ffb627'
