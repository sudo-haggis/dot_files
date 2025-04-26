# Soft Light Theme for tmux (Easy on the eyes)

# Add Catppuccin plugin
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Warm soft colors for panes
set -g pane-border-style fg='#b8c0ca'
set -g pane-active-border-style fg='#6c7a89'

# Window style - using a soft beige for inactive
setw -g window-style 'bg=#f0ebe2,fg=#5d6d7e'

# Window style - using a warmer paper tone for active
setw -g window-active-style 'bg=#f5f0e7,fg=#2c3e50'

# Status line base color
set -g status-style 'bg=#e4dfd3,fg=#5d6d7e'

# Window status format - with good contrast
set -g window-status-format "#[fg=#5d6d7e,bg=#e4dfd3,nobold] #I #[fg=#5d6d7e,bg=#e4dfd3] #W "
set -g window-status-current-format "#[fg=#f5f0e7,bg=#5d6d7e,nobold] #I #[fg=#f5f0e7,bg=#5d6d7e,bold] #W "

# Status bar elements
set -g status-left "#[fg=#f5f0e7,bg=#7e8c8d,bold] #S "
set -g status-right "#[fg=#f5f0e7,bg=#7e8c8d,bold] %H:%M "

# Catppuccin config
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
