# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            ~/.bashrc Configuration                           ║
# ║                    Executed by bash(1) for non-login shells                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            Alias for config editin                          │ 
# │              if .bashrc doesnt run, you can edit bash files quickly         │
# └─────────────────────────────────────────────────────────────────────────────┘
alias nvimBASH='cd ~/.dotfiles/bash/ && nvim .bash_aliases_tools .bash_aliases_projects .bash_functions .bashrc'

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            Interactive Shell Check                          │
# └─────────────────────────────────────────────────────────────────────────────┘
case $- in
    *i*) ;;
      *) return;;
esac

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              History Configuration                          │
# └─────────────────────────────────────────────────────────────────────────────┘
# Enhanced history management with separate bash and tmux storage

# Create history directories if they don't exist
mkdir -p "$HOME/.history/bash"
mkdir -p "$HOME/.history/tmux"

# Enhanced history settings
HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and lines starting with space
HISTSIZE=10000                    # Increased in-memory history
HISTFILESIZE=50000               # Increased history file size
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "  # Add timestamps to history

# Append to history file, don't overwrite
shopt -s histappend

# Save history after each command (useful for tmux)
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Set history file location based on environment
if [ -n "$TMUX" ]; then
    # Tmux environment: per-pane history
    export HISTFILE="$HOME/.history/tmux/session_$(tmux display-message -p '#S')_window_$(tmux display-message -p '#I')_pane_$(tmux display-message -p '#P')"
else
    # Regular bash: standard history file
    export HISTFILE="$HOME/.history/bash/bash_history"
fi

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Shell Options                                  │
# └─────────────────────────────────────────────────────────────────────────────┘
# Check window size after each command
shopt -s checkwinsize

# Enable "**" pattern matching (commented out by default)
#shopt -s globstar

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              System Utilities                               │
# └─────────────────────────────────────────────────────────────────────────────┘
# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set chroot identification variable
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Prompt Configuration                           │
# └─────────────────────────────────────────────────────────────────────────────┘
# Detect color terminal support
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Force color prompt (uncomment to enable)
#force_color_prompt=yes

# Color capability test
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Standard prompt setup (overridden below with custom prompt)
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Set xterm title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Color Support                                  │
# └─────────────────────────────────────────────────────────────────────────────┘
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    
    # Color aliases for grep family
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors (uncomment to enable)
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                           External Configuration Files                      │
# └─────────────────────────────────────────────────────────────────────────────┘
# Load custom mainly tool aliases
if [ -f ~/.bash_aliases_tools ]; then
    . ~/.bash_aliases_tools
fi

# Load project-specific aliases (if exists)
if [ -f ~/.bash_aliases_project ]; then
    . ~/.bash_aliases_project
fi

# Load custom functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

#load custom tools (zoxide etc)
if [ -f ~/.bash_tools ]; then
    . ~/.bash_tools
fi

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                           Completion Configuration                          │
# └─────────────────────────────────────────────────────────────────────────────┘
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Terminal Behavior                              │
# └─────────────────────────────────────────────────────────────────────────────┘
# Enable vi-style controls in terminal
set -o vi

# Remove ctrl+x binding to prevent nano from launching
bind -r '\C-x'

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Custom Prompt                                  │
# └─────────────────────────────────────────────────────────────────────────────┘
# Custom prompt with shortened path (overrides standard PS1 above)
PS1='\[\033[01;34m\]$(shorten_path)\[\033[00m\]$ '

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Keyboard Layout                                │
# └─────────────────────────────────────────────────────────────────────────────┘
# Map caps lock to escape
setxkbmap -option caps:escape

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                              Environment Setup                              │
# └─────────────────────────────────────────────────────────────────────────────┘
# Load envman configuration
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# new and improoved $PATH generationisation! 
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "/snap/bin" ] && PATH="$PATH:/snap/bin"
[ -d "$HOME/go/bin" ] && PATH="$PATH:$HOME/go/bin"
[ -d "$HOME/.local/opt/go/bin" ] && PATH="$HOME/.local/opt/go/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
export PATH
