#fuzzehh finder on ripgrep results, the ultimate (well for me) file search and finder options for a temrinal, boosh!
# Define the core search function
rgfzf() {
  local query="$1"
  local path="${2:-.}"
  local preview_cmd="line=\$(echo {} | cut -d: -f2); start=\$((line-5 > 0 ? line-5 : 1)); bat --color=always --highlight-line \$line --line-range \$start:\$((line+5)) \$(echo {} | cut -d: -f1) 2>/dev/null || rg --color=always --context 5 '$query' \$(echo {} | cut -d: -f1)"
  
  rg --line-number "$query" "$path" | fzf --ansi --preview "$preview_cmd" --preview-window=up:60%
}

# Use rgfzf to build nvimrg
nvimrg() {
  local selection=$(rgfzf "$1" "$2")
  
  if [ -n "$selection" ]; then
    local file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)
    nvim "$file" +"$line"
  fi
}

copy_code() {
    #sanitise the copyingf input for code copyiong purposese
    cat | sed 's/\x1B\[[0-9;]*[JKmsu]//g' | sed 's/\r$//' | sed 's/[ \t]*$//' | copy
    echo -e "\033[36m"
    echo "   < Code sanitized! >"
    echo "   ----------------"
    echo "          \   ^__^"
    echo "           \  (oo)\_______"
    echo "              (__)\       )\/\\"
    echo "                  ||----w |"
    echo "                  ||     ||"
    echo -e "\033[0m"
}
