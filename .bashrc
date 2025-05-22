# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -n "$TMUX" ]; then
    export HISTFILE="$HOME/.bash_history_tmux_$(tmux display-message -p '#I-#P')"
fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

#trap 'echo "DEBUG trap: $BASH_COMMAND in ${BASH_SOURCE[0]}"' DEBUG

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#trap - DEBUG

#set vi style controlls in terminal... be brave! 
set -o vi


# Function to shorten directory path
# Shows only the last 2 directories in the path
shorten_path() {
  local pwd_length=${#PWD}
  
  # If in home directory, use ~
  if [[ $PWD == $HOME* ]]; then
    local relative_path=${PWD#$HOME}
    
    # If exactly in home directory
    if [[ -z "$relative_path" ]]; then
      echo "~"
      return
    fi
    
    # Get last 2 directories from path
    local short=$(echo "$relative_path" | rev | cut -d'/' -f1,2 | rev)
    echo "~/.../$short"
  else
    # Not in home directory
    # Get last 2 directories from path
    local short=$(echo "$PWD" | rev | cut -d'/' -f1,2 | rev)
    echo ".../$(basename $(dirname $short))/$(basename $PWD)"
  fi
}

#copy contents of files for claude, bespoke cat + concat command simply.    
copy_files(){
    if [ $# -eq 0 ]; then
        echo "Try adding some directories as parameters"
        return 1
    fi

    local OUTPUT=""
    local FILES=()

    for arg in "$@"; do
        FILES+=("$arg")
    done

    for file in "${FILES[@]}"; do
        if [ -f "$file" ]; then

            OUTPUT+="====$file====\n\n"

            OUTPUT+="$(cat "$file")\n\n"

            OUTPUT+="====EOF $file====\n\n"

            echo "Added contents of $file"
        else 
            echo "$file NOT FOUND"
        fi
    done

    #echo -e "$OUTPUT"
    printf "%b" "$OUTPUT"
}




# Set the prompt - no username or hostname, just the shortened path
PS1='\[\033[01;34m\]$(shorten_path)\[\033[00m\]$ '

# Custom aliases
#alias ll='exa -l --icons --git'
#alias la='exa -lg --icons --git'
#alias lt='exa -T --icons --git-ignore'
#alias copy='xclip -selection clipboard'
#alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Ports | printf \"%.12s\"}}\t{{.Status}}"'
#alias dckUp='docker compose up -d'
#alias dckDown='docker compose down'
#alias dckBuild='docker compose build --no-cache'
#alias dckWatch='watch -n 5 "docker ps -a --format \"table {{.Names}}\t{{.Ports | printf \\\"%.12s\\\"}}\t{{.Status | printf \\\"%.5s\\\"}}\"" '
#alias dckStat='docker stats'
#alias dckLog='docker logs -n 15'
#alias dckExecDB='docker exec -it latepoint_db '
#alias batlog='sed "s/; public /;\n  public /g" | sed "s/; protected /;\n  protected /g" | bat --theme=ansi --language=log --color=always'
#alias cdlpdev='cd ~/webDev/latepoint_dev && echo "Welcome..." && git status'
#alias cdgatecodes='cd ~/webDev/latepoint_dev/wp-content-lp5/plugins/latepoint-gate-codes/ && echo "Welcome..." && git status'
#alias dotfiles='git --git-dir=/home/weedavedev/.dotfiles/ --work-tree=/home/weedavedev'
#
##alias for gatecodes
#alias copyGatecodes='copy_files latepoint-gate-codes.php assets/css/latepoint-gate-codes.css | copy'
#alias nvimGatecodes='nvim latepoint-gate-codes.php assets/css/latepoint-gate-codes.css'
##ltdr alias
#alias copyLTDR='copy_files docker-compose.yaml docker/php/Dockerfile docker/php/docker-entrypoint.sh docker/mysql/Dockerfile | copy'
#alias nvimLTDR='nvim docker-compose.yaml docker/php/Dockerfile docker/php/docker-entrypoint.sh docker/mysql/Dockerfile'  
#alias dckLogLP5='docker logs latepoint_wordpress_lp5 -n 15'
#alias dckExecLP5='docker exec -it latepoint_wordpress_lp5 '

if [ -f ~/.bash_tools ]; then
	. ~/.bash_tools
fi

#remove binding for ctrl+x so nano stops launching randomly
bind -r '\C-x'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH="/home/weedavedev/.local/bin:/home/weedavedev/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/weedavedev/go/bin:/home/weedavedev/bootdev/worldbanc/private/bin"
export PATH="$HOME/.local/opt/go/bin:$PATH"
