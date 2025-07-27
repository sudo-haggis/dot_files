# ============================================================================
# LIGHT THEME with Colored Git Branch  
# Replace your ~/.config/tmux/themes/light.tmux with this
# ============================================================================

# Improved Light Theme for tmux (proper contrast and readability)

# Add Catppuccin plugin
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Improved light colors for panes - better contrast
set -g pane-border-style fg='#c4c8da'
set -g pane-active-border-style fg='#6f7bb6'

# Window style - clean light background that matches Neovim
setw -g window-style 'bg=#f7f7f7,fg=#3760bf'
setw -g window-active-style 'bg=#ffffff,fg=#1e1e2e'

# Status line base color - good contrast
set -g status-style 'bg=#e1e2e7,fg=#3760bf'

# ENHANCED: Git branch with custom colors for light theme
set -g status-right-length 100
set -g status-right "#[fg=#587539,bg=#e1e2e7,bold]#(cd #{pane_current_path}; git branch --show-current 2>/dev/null | sed 's/^/ ⎇ /' | sed 's/$/ /')#[fg=#166775,bg=#e1e2e7]#(cd #{pane_current_path}; git status --porcelain 2>/dev/null | wc -l | sed 's/0/✓/' | sed 's/[1-9][0-9]*/~/' | sed 's/^/ [/' | sed 's/$/ ]/')#[fg=#ffffff,bg=#6f7bb6,bold] %H:%M "

# Improved Window status format - much better contrast for visibility
set -g window-status-format "#[fg=#3760bf,bg=#e1e2e7,nobold] #I #[fg=#3760bf,bg=#e1e2e7] #W "
set -g window-status-current-format "#[fg=#ffffff,bg=#6f7bb6,nobold] #I #[fg=#ffffff,bg=#6f7bb6,bold] #W "

# Status bar elements - proper contrast
set -g status-left "#[fg=#ffffff,bg=#6f7bb6,bold] #S "

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
