# BASH_ALIASES 
# - includes a personal projects alias file, i include this on my own personal local branch 
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases_projects
fi
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# # # # # # # # # # # # # #
# # # Custom aliases# # # # 
# # # # # # # # # # # # # #

#---- Misc aliases -------#
alias nvimAlias='nvim ~/.bash_aliases'

#- Directory informatics -#
alias ll='exa -l --icons --git'
#alias la='exa -lg --icons --git'
alias la='exa -la --no-git --no-time --no-user --no-filesize'
alias lt='exa -T --icons --git-ignore'

#-- TOOLS --#
alias copy='xclip -selection clipboard' 
alias ccopy='copy_code' #includes cows

## file managment 
alias batlog='sed "s/; public /;\n  public /g" | sed "s/; protected /;\n  protected /g" | bat --theme=ansi --language=log --color=always'
##directory managment
alias Tree='tree --filelimit 20 -a -C  -I "node_modules|.git|dist|build|coverage" -L'
alias WatchTree='watch -n 5 tree -d --filelimit 10 -a  -I "node_modules|.git|dist|build|coverage" -C -L'

alias py='python3 ' 
#--- Docker commands ----#
#- Any docker --#
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Ports | printf \"%.12s\"}}\t{{.Status}}"'
alias dckUp='docker compose up -d'
alias dckDown='docker compose down'
alias dckBuild='docker compose build --no-cache'
alias dckWatch='watch -n 5 "docker ps -a --format \"table {{.Names}}\t{{.Ports | printf \\\"%.12s\\\"}}\t{{.Status | printf \\\"%.5s\\\"}}\"" '
alias dckStat='docker stats'
alias dckLog='docker logs -n 15'

## JUMP Around ##
## mostly replaced by z (zoxide) but still fast
alias cdlpdev='cd ~/webDev/latepoint_dev && echo "Welcome..." && git status'
alias cdgatecodes='cd ~/webDev/latepoint_dev/wp-content-lp5/plugins/latepoint-gate-codes/ && echo "Welcome..." && git status'

# Program specific aliases 
#the start of the gir aliasathon... aparently there will be more of these
alias GGraph='git log --graph --oneline --all -n 10'
alias GGraph30='git log --graph --oneline --all -n 30'
alias GBranch='git branch'
#alias GStatus='git status' # removed, simple enough and complicates getting to other alias. updated GStatus below to use -s and untraceked=no
alias GStatus='git status -s --untracked-files=no'
alias GStaged='git diff --name-only --staged'
alias GSNotStaged='git diff --name-only'

alias README_TEMPLATE='rsync -av /home/weedavedev/workspace/gist.github.com/sudo-haggis/GIST_TEMPLATE/README.md ./'

## Project specific aliases ## 
