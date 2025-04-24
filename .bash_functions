#fuzzehh finder on ripgrep results, the ultimate (well for me) file search and finder options for a temrinal, boosh!
rgfzf() {
  rg --line-number "$1" "$2" | fzf --ansi \
    --preview "rg --color=always --context 5 --line-number '$1' \$(echo {} | cut -d: -f1) | grep -C 5 -A 5 \$(echo {} | cut -d: -f2)" \
    --preview-window=up:60%
}

nvimrg() {
    nvim $(rg -l "$1" "$2" | fzf)
}
