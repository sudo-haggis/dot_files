# Tokyo Night Dark Theme for tmux

# Add Catppuccin plugin (if not in main config)
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Tokyo Night Storm colors for panes
set -g pane-border-style fg='#3b4261'
set -g pane-active-border-style fg='#7aa2f7'

# Window style (inactive)
setw -g window-style 'bg=#1a1b26'

# Window style (active)
setw -g window-active-style 'bg=#24283b'

# Customize Catppuccin colors to be more like Tokyo Night
set -g @catppuccin_flavour 'mocha' # or latte, frappe, macchiato
set -g @catppuccin_status_modules_right "date_time"
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"
set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

# Window status format
set -g window-status-format "#[fg=colour244,bg=colour234,nobold,noitalics,nounderscore] #I #[fg=colour244,bg=colour234] #W "
set -g window-status-current-format "#[fg=colour234,bg=colour31,nobold,noitalics,nounderscore] #I #[fg=colour231,bg=colour31,bold] #W "

# Status right with time
set -g status-right "#[fg=colour231,bg=colour31,bold] %H:%M "

# Override Catppuccin window formats to use #W (window name) only
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator ""
set -g @catppuccin_window_middle_separator " "
set -g @catppuccin_window_number_position "left"
set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_default_text "#W"
set -g @catppuccin_window_current_text "#W"

# Optional: Status left with session name
set -g status-left "#[fg=colour231,bg=colour31,bold] #S "
