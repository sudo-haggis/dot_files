
# Custom aliases
alias nvimAlias='nvim ~/.bash_aliases'

alias ll='exa -l --icons --git'
alias la='exa -lg --icons --git'
alias lt='exa -T --icons --git-ignore'
alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Ports | printf \"%.12s\"}}\t{{.Status}}"'
alias dckUp='docker compose up -d'
alias dckDown='docker compose down'
alias dckBuild='docker compose build --no-cache'
alias dckWatch='watch -n 5 "docker ps -a --format \"table {{.Names}}\t{{.Ports | printf \\\"%.12s\\\"}}\t{{.Status | printf \\\"%.5s\\\"}}\"" '
alias dckStat='docker stats'
alias dckLog='docker logs -n 15'
alias dckExecDB='docker exec -it latepoint_db '
alias batlog='sed "s/; public /;\n  public /g" | sed "s/; protected /;\n  protected /g" | bat --theme=ansi --language=log --color=always'
alias cdlpdev='cd ~/webDev/latepoint_dev && echo "Welcome..." && git status'
alias cdgatecodes='cd ~/webDev/latepoint_dev/wp-content-lp5/plugins/latepoint-gate-codes/ && echo "Welcome..." && git status'
alias dotfiles='git --git-dir=/home/weedavedev/.dotfiles/ --work-tree=/home/weedavedev'

#alias for gatecodes
alias copyGatecodes='copy_files latepoint-gate-codes.php assets/css/latepoint-gate-codes.css | copy'
alias nvimGatecodes='nvim latepoint-gate-codes.php assets/css/latepoint-gate-codes.css'
#ltdr alias
alias copyLTDR='copy_files docker-compose.yaml docker/php/Dockerfile docker/php/docker-entrypoint.sh docker/mysql/Dockerfile | copy'
alias nvimLTDR='nvim docker-compose.yaml docker/php/Dockerfile docker/php/docker-entrypoint.sh docker/mysql/Dockerfile'  
alias dckLogLP5='docker logs latepoint_wordpress_lp5 -n 15'
alias dckExecLP5='docker exec -it latepoint_wordpress_lp5 '
alias cdresources='cd ~/webDev/resources '
alias cdpluginZip='cd ~/webDev/resources/wordpress_scripts/build_scripts/plugin_zipperooo'

#tree outputs
alias Tree='tree --filelimit 20 -a -C  -I "node_modules|.git|dist|build|coverage" -L'
alias WatchTree='watch -n 5 tree -d --filelimit 10 -a  -I "node_modules|.git|dist|build|coverage" -C -L'

alias copy='xclip -selection clipboard'
alias ccopy='copy_code'

alias py='python3 ' 

#the start of the gir aliasathon... aparently there will be more of these
alias GGraph='git log --graph --oneline --all -n 10'
alias GBranch='git branch'
alias GStatus='git status'
