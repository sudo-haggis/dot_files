# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              Bash Functions                                 ║
# ║                     Custom functions for enhanced workflow                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            Search & Navigation                              │
# └─────────────────────────────────────────────────────────────────────────────┘

# ── Fuzzy Search with Ripgrep ──
# Ultimate file search using ripgrep + fzf with preview
rgfzf() {
    local query="$1"
    local path="${2:-.}"
    local preview_cmd="line=\$(echo {} | cut -d: -f2); start=\$((line-5 > 0 ? line-5 : 1)); bat --color=always --highlight-line \$line --line-range \$start:\$((line+5)) \$(echo {} | cut -d: -f1) 2>/dev/null || rg --color=always --context 5 '$query' \$(echo {} | cut -d: -f1)"
    
    rg --line-number "$query" "$path" | fzf --ansi --preview "$preview_cmd" --preview-window=up:60%
}

# ── Search and Edit ──
# Search with rgfzf and open result in nvim at the exact line
nvimrg() {
    local selection=$(rgfzf "$1" "$2")
    
    if [ -n "$selection" ]; then
        local file=$(echo "$selection" | cut -d: -f1)
        local line=$(echo "$selection" | cut -d: -f2)
        nvim "$file" +"$line"
    fi
}

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                           Content Management                                │
# └─────────────────────────────────────────────────────────────────────────────┘

# ── Code Sanitization ──
# Clean and copy code with celebration cow
copy_code() {
    # Sanitize input: remove ANSI codes, carriage returns, trailing spaces
    cat | sed 's/\x1B\[[0-9;]*[JKmsu]//g' | sed 's/\r$//' | sed 's/[ \t]*$//' | copy
    
    # Victory celebration with ASCII cow
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

# ── File Concatenation ──
# Copy contents of multiple files for sharing with Claude
copy_files() {
    if [ $# -eq 0 ]; then
        echo "Try adding some directories as parameters"
        return 1
    fi

    local OUTPUT=""
    local FILES=()

    # Collect all file arguments
    for arg in "$@"; do
        FILES+=("$arg")
    done

    # Process each file
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

    # Output the concatenated content
    printf "%b" "$OUTPUT"
}

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │                            Prompt Utilities                                 │
# └─────────────────────────────────────────────────────────────────────────────┘

# ── Path Shortening ──
# Display abbreviated directory path in prompt
# Shows only the last 2 directories for readability
shorten_path() {
    local pwd_length=${#PWD}
    
    # Handle home directory cases
    if [[ $PWD == $HOME* ]]; then
        local relative_path=${PWD#$HOME}
        
        # Exactly in home directory
        if [[ -z "$relative_path" ]]; then
            echo "~"
            return
        fi
        
        # Get last 2 directories from home-relative path
        local short=$(echo "$relative_path" | rev | cut -d'/' -f1,2 | rev)
        echo "~/.../$short"
    else
        # Not in home directory - show last 2 directories
        local short=$(echo "$PWD" | rev | cut -d'/' -f1,2 | rev)
        echo ".../$(basename $(dirname $short))/$(basename $PWD)"
    fi
}
