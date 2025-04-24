#fuzzehh finder on ripgrep results, the ultimate (well for me) file search and finder options for a temrinal, boosh!
rgfzf() {
    rg --line-number --color=always "$1" "$2" | fzf --ansi    
}

nvimrg() {
    nvim $(rg -l "$1" "$2" | fzf)
}
