# Medium/Dawn Theme for tmux (easier on morning eyes!)
# Softer than bright white, warmer than pure light theme

# Add Catppuccin plugin
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'

# Medium theme colors - warm grays and muted tones
set -g pane-border-style fg='#a6adc8'
set -g pane-active-border-style fg='#89b4fa'

# Window style - warm off-white background (easier than pure white)
setw -g window-style 'bg=#eff1f5,fg=#4c4f69'

# Window style (active) - slightly cooler for contrast
setw -g window-active-style 'bg=#e6e9ef,fg=#1e1e2e'

# Status line - warm medium gray
set -g status-style 'bg=#dce0e8,fg=#4c4f69'

# Window status format - medium contrast (not harsh)
set -g window-status-format "#[fg=#4c4f69,bg=#dce0e8,nobold] #I #[fg=#4c4f69,bg=#dce0e8] #W "
set -g window-status-current-format "#[fg=#eff1f5,bg=#89b4fa,nobold] #I #[fg=#eff1f5,bg=#89b4fa,bold] #W "

# Status bar elements - comfortable medium blue
set -g status-left "#[fg=#eff1f5,bg=#89b4fa,bold] #S "
set -g status-right "#[fg=#eff1f5,bg=#89b4fa,bold] %H:%M "

# Catppuccin config - latte flavor but with custom overrides
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

# Message styling - comfortable on medium background
set -g message-style bg='#89b4fa',fg='#eff1f5'
set -g message-command-style bg='#89b4fa',fg='#eff1f5'

# Copy mode highlighting - visible but not harsh
set -g mode-style bg='#bcc0cc',fg='#4c4f69'

# Clock mode color
set -g clock-mode-colour '#89b4fa'
