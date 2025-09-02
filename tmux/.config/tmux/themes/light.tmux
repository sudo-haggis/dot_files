# Improved Light Theme for tmux (proper contrast and readability)

# Add Catppuccin plugin
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Improved light colors for panes - better contrast
set -g pane-border-style fg='#c4c8da'
set -g pane-active-border-style fg='#6f7bb6'

# Window style - clean light background that matches Neovim
setw -g window-style 'bg=#fafafa,fg=#2e3440'

# Window style (active) - slightly different shade for contrast
setw -g window-active-style 'bg=#ffffff,fg=#1e1e2e'

# Status line base color - good contrast
set -g status-style 'bg=#e1e2e7,fg=#3760bf'

# Improved Window status format - much better contrast for visibility
set -g window-status-format "#[fg=#3760bf,bg=#e1e2e7,nobold] #I #[fg=#3760bf,bg=#e1e2e7] #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#6f7bb6,nobold] #I #[fg=#ffffff,bg=#6f7bb6,bold] #W "

# Status bar elements - proper contrast
set -g status-left "#[fg=#ffffff,bg=#6f7bb6,bold] #S "
set -g status-right "#[fg=#ffffff,bg=#6f7bb6,bold] %H:%M "

# Catppuccin config - latte flavor for light mode
set -g @catppuccin_flavour 'latte'
set -g @catppuccin_status_modules_right "date_time"
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"
set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

# Override Catppuccin window formats
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator ""
set -g @catppuccin_window_middle_separator " "
set -g @catppuccin_window_number_position "left"
set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_default_text "#W"
set -g @catppuccin_window_current_text "#W"

# Message styling (for notifications) - readable on light background
set -g message-style bg='#6f7bb6',fg='#ffffff'
set -g message-command-style bg='#6f7bb6',fg='#ffffff'

# Copy mode highlighting - visible selection
set -g mode-style bg='#b6bfe2',fg='#1e1e2e'

# Clock mode color (when you press prefix + t)
set -g clock-mode-colour '#6f7bb6'
