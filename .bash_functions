#fuzzehh finder on ripgrep results, the ultimate (well for me) file search and finder options for a temrinal, boosh!
rgfzf() {
  rg --line-number "$1" "$2" | fzf --ansi \
    --preview "rg --color=always --context 5 --line-number '$1' \$(echo {} | cut -d: -f1) | grep -C 5 -A 5 \$(echo {} | cut -d: -f2)" \
    --preview-window=up:60%
}

nvimrg() {
  local selection=$(rg --line-number "$1" "$2" | fzf --ansi \
    --preview "bat --color=always --highlight-line \$(echo {} | cut -d: -f2) \$(echo {} | cut -d: -f1) 2>/dev/null || rg --color=always --context 5 --line-number '$1' \$(echo {} | cut -d: -f1)" \
    --preview-window=up:60%)
  
  if [ -n "$selection" ]; then
    local file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)
    nvim "$file" +"$line"
  fi
}
