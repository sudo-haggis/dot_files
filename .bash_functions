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


