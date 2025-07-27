# ============================================================================
# DARK THEME with Colored Git Branch
# Add this to your ~/.config/tmux/themes/dark.tmux
# ============================================================================

# Improved Tokyo Night Dark Theme for tmux (softer, more readable)

# Add Catppuccin plugin (if not in main config)
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Softer Tokyo Night colors for panes (less harsh than original)
set -g pane-border-style fg='#414868'
set -g pane-active-border-style fg='#7aa2f7'

# Window style - softer background that matches Neovim
setw -g window-style 'bg=#24283b'
setw -g window-active-style 'bg=#2f3549'

# Customize Catppuccin colors to match improved Tokyo Night
set -g @catppuccin_flavour 'mocha'
set -g @catppuccin_status_modules_right "date_time"
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"
set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

# ENHANCED: Git branch with custom colors and status
set -g status-right-length 100
set -g status-right "#[fg=#9ece6a,bg=#414868,bold]#(cd #{pane_current_path}; git branch --show-current 2>/dev/null | sed 's/^/ ⎇ /' | sed 's/$/ /')#[fg=#7aa2f7,bg=#414868]#(cd #{pane_current_path}; git status --porcelain 2>/dev/null | wc -l | sed 's/0/✓/' | sed 's/[1-9][0-9]*/~/' | sed 's/^/ [/' | sed 's/$/ ]/')#[fg=#24283b,bg=#7aa2f7,bold] %H:%M "

# Improved Window status format - better contrast and readability
set -g window-status-format "#[fg=#c0caf5,bg=#32394a,nobold,noitalics,nounderscore] #I #[fg=#c0caf5,bg=#32394a] #W "
set -g window-status-current-format "#[fg=#24283b,bg=#7aa2f7,nobold,noitalics,nounderscore] #I #[fg=#24283b,bg=#7aa2f7,bold] #W "

# Override Catppuccin window formats to use #W (window name) only
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator ""
set -g @catppuccin_window_middle_separator " "
set -g @catppuccin_window_number_position "left"
set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_default_text "#W"
set -g @catppuccin_window_current_text "#W"

# Status left with session name - improved colors
set -g status-left "#[fg=#24283b,bg=#7aa2f7,bold] #S "

# Message styling (for notifications)
set -g message-style bg='#414868',fg='#c0caf5'
set -g message-command-style bg='#414868',fg='#c0caf5'

# Copy mode highlighting
set -g mode-style bg='#364a82',fg='#c0caf5'
