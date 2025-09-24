# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              Bash Functions                                 ║
# ║                     Custom functions for enhanced workflow                  ║
# ║                    FIXED: Terminal wrapping issues resolved                 ║
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
# │                    FIXED: GIT-ENHANCED PROMPT UTILITIES                    │
# └─────────────────────────────────────────────────────────────────────────────┘
 
# Function to set up git completion for aliases
setup_git_completion() {
    # Check if git completion is available
    if ! type __git_complete &>/dev/null; then
        # Try to load git completion if not already loaded
        if [ -f /usr/share/bash-completion/completions/git ]; then
            source /usr/share/bash-completion/completions/git
        elif [ -f /etc/bash_completion.d/git ]; then
            source /etc/bash_completion.d/git
        elif [ -f ~/.local/share/bash-completion/completions/git ]; then
            source ~/.local/share/bash-completion/completions/git
        fi
    fi
    
    # Set up completion for each alias (if __git_complete is available)
    if type __git_complete &>/dev/null; then
        __git_complete GSW _git_switch
        __git_complete GB _git_branch  
        __git_complete GCO _git_checkout
        __git_complete GM _git_merge
        __git_complete GR _git_rebase
        __git_complete GP _git_push
        __git_complete GF _git_fetch
        __git_complete GL _git_log
        
        echo "🏴‍☠️ Git alias completion loaded successfully, captain!"
    else
        echo "⚠️  Git completion functions not found - basic aliases still work"
    fi
}

# Run the setup function
setup_git_completion

# ── FINAL FIX: Git Branch Function (Self-Bracketed) ──
git_branch_prompt() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Get just the part after the last slash
        local short_branch="${branch##*/}"
        
        # Check git status for simple indicator (no colors)
        local status=$(git status --porcelain 2>/dev/null)
        local indicator
        
        if [ -z "$status" ]; then
            indicator="✓"  # Clean repo
        elif echo "$status" | grep -q "^M\|^ M"; then
            indicator="●"  # Modified files
        elif echo "$status" | grep -q "^A\|^ A"; then
            indicator="+"  # Staged files
        else
            indicator="!"  # Other changes
        fi
        
        # Return plain text only
        echo " (${indicator}${short_branch})"
    fi
}

# THE FINAL COUUNT DOWN! well not really. 
nvim_diff_files() {
    local file="$1"
    local commit="${2:-HEAD}"

    if [ -z "$file" ]; then 
        echo "Usage: nvim_diff_files <file> [commit]"
        echo "eg: nvim_diff_files miscelaniousfile.js HEAD~2"
    fi

   local temp_file="./git_$(basename "$file")_$commit"
    git show "$commit:$file" > "$temp_file" 2>/dev/null || {
        echo "File $file Not found in $commit"
        return 1
    }

    nvim -d "$file" "$temp_file" 
}


# ── Streamlined Path Display ──
# Shows abbreviated path + FULL current directory name
shorten_path() {
    local current_dir=$(basename "$PWD")
    
    if [[ $PWD == $HOME ]]; then
        # Just home
        echo "~"
    elif [[ $PWD == $HOME/* ]]; then
        # Inside home - show ~/…/current_directory
        local parent_dir=$(dirname "$PWD")
        if [[ $parent_dir == $HOME ]]; then
            # Direct child of home
            echo "~/$current_dir"
        else
            # Deeper - show ~/…/current_dir
            echo "~/…/$current_dir"
        fi
    else
        # Outside home - show /…/current_directory
        local parent_dir=$(dirname "$PWD")
        if [[ $(dirname "$parent_dir") == "/" ]]; then
            # Direct child of root
            echo "$PWD"
        else
            # Deeper - show /…/current_dir
            echo "/…/$current_dir"
        fi
    fi
}

# ── Quick Toggle Commands (simplified) ──
prompt_minimal() {
    # Just current directory + git
    PS1='\[\033[01;34m\]\W\[\033[00m\]$(git_branch_prompt)$ '
    echo "🏴‍☠️ Minimal prompt active"
}

prompt_standard() {
    # Your streamlined prompt
    PS1='\[\033[01;34m\]$(shorten_path)\[\033[00m\]$(git_branch_prompt)$ '
    echo "🏴‍☠️ Standard streamlined prompt active"
}

# ── Aliases ──
alias pm='prompt_minimal'
alias ps='prompt_standard'

# ── Keyboard Setup ──
setup_caps_escape() {
    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        setxkbmap -option caps:escape 2>/dev/null 
    else
        echo "🏴‍☠️ No graphical session detected, skipping caps lock mapping"
    fi
}
