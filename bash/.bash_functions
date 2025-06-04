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
# ── Streamlined Git Status Function ──
# Compact git status with essential info in ~10 lines
GitStatus() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not a git repository"; return 1
    fi
    
    # Current branch and upstream status
    local branch=$(git branch --show-current)
    local upstream=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
    local status_line="⚓ Branch: ${branch:-'(detached)'}"
    
    if [ -n "$upstream" ]; then
        local ahead_behind=$(git rev-list --left-right --count HEAD...$upstream 2>/dev/null | tr '\t' '/')
        [ "$ahead_behind" != "0/0" ] && status_line+=" (${ahead_behind} ahead/behind)"
    fi
    echo "$status_line"
    
    # File counts
    local staged=$(git diff --cached --name-only | wc -l)
    local modified=$(git diff --name-only | wc -l)
    echo "📁 Files: ${staged} staged, ${modified} modified"
    
    # Time since last commit with visual timeline
    local last_commit_epoch=$(git log -1 --format=%ct 2>/dev/null)
    if [ -n "$last_commit_epoch" ]; then
        local now_epoch=$(date +%s)
        local diff_seconds=$((now_epoch - last_commit_epoch))
        local hours=$((diff_seconds / 3600))
        local days=$((hours / 24))
        
        if [ $days -gt 0 ]; then
            local timeline=""
            if [ $days -le 7 ]; then
                timeline=$(printf '🟢%.0s' $(seq 1 $days))$(printf '⚪%.0s' $(seq 1 $((7-days))))
            else
                timeline="🔴🔴🔴🔴🔴🔴🔴"
            fi
            echo "⏰ Last commit: ${days}d ago $timeline"
        else
            local timeline=""
            if [ $hours -le 12 ]; then
                local dots=$((hours / 2 + 1))
                timeline=$(printf '🟢%.0s' $(seq 1 $dots))$(printf '⚪%.0s' $(seq 1 $((6-dots))))
            else
                timeline="🟡🟡🟡🟡🟡🟡"
            fi
            echo "⏰ Last commit: ${hours}h ago $timeline"
        fi
    fi
    
    # Show actual file status if any changes exist
    if [ $staged -gt 0 ] || [ $modified -gt 0 ]; then
        git status -s --untracked-files=no | head -8 | sed 's/^/   /'
    else
        echo "✨ Working tree clean"
    fi
}

# ── Keyboard Setup ──
setup_caps_escape() {
    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        setxkbmap -option caps:escape 2>/dev/null 
    else
        echo "🏴‍☠️ No graphical session detected, skipping caps lock mapping"
    fi
}
