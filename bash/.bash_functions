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

# ── FIXED: Git Branch Function (No Raw Escape Sequences) ──
# Quick git branch detection for prompt - returns plain text for PS1 processing
git_branch_prompt() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check git status for status indicator (no colors here!)
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
        
        # Return plain text - let PS1 handle the coloring
        echo " (${indicator}${branch})"
    fi
}

# ── FIXED: Enhanced Path Shortening ──
# Display abbreviated directory path with consistent length for terminal
shorten_path() {
    local max_path_length=35  # Consistent max length to prevent wrapping
    local git_info=$(git_branch_prompt)
    local path_part=""
    
    # Handle home directory cases
    if [[ $PWD == $HOME* ]]; then
        local relative_path=${PWD#$HOME}
        
        # Exactly in home directory
        if [[ -z "$relative_path" ]]; then
            path_part="~"
        else
            # Get last 2 directories from home-relative path
            local short=$(echo "$relative_path" | rev | cut -d'/' -f1,2 | rev)
            path_part="~/…/$short"
        fi
    else
        # Not in home directory - show last 2 directories
        local short=$(echo "$PWD" | rev | cut -d'/' -f1,2 | rev)
        path_part="…/$short"
    fi
    
    # Combine path and git info, truncate if too long
    local full_prompt="${path_part}${git_info}"
    if [ ${#full_prompt} -gt $max_path_length ]; then
        # Truncate path part to make room for git info
        local available_space=$((max_path_length - ${#git_info} - 3))
        path_part="${path_part:0:$available_space}…"
        full_prompt="${path_part}${git_info}"
    fi
    
    echo "$full_prompt"
}

# ── Enhanced Git Status Function ──
# Compact git status with essential info and helpful reminders
GitStatus() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not a git repository"
        echo "💡 Tip: Run 'git init' to initialize or check if you're in the right directory"
        return 1
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
    
    # File counts with commit reminders
    local staged=$(git diff --cached --name-only | wc -l)
    local modified=$(git diff --name-only | wc -l)
    local untracked=$(git ls-files --others --exclude-standard | wc -l)
    
    echo "📁 Files: ${staged} staged, ${modified} modified, ${untracked} untracked"
    
    # Git workflow reminders based on current state
    if [ $staged -gt 0 ]; then
        echo "🚀 Ready to commit! Remember: type(scope): this will... <message>"
    elif [ $modified -gt 0 ]; then
        echo "📝 Modified files ready for staging (git add)"
    fi
    
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
                echo "⚠️  Long time since last commit - consider breaking work into smaller chunks"
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
        
        # Quick .gitignore reminder
        if [ $untracked -gt 0 ]; then
            echo "💡 Don't forget to update .gitignore for untracked files if needed"
        fi
    else
        echo "✨ Working tree clean"
        
        # README reminder for clean repos
        if [ -f "README.md" ]; then
            local readme_age=$(stat -c %Y README.md 2>/dev/null || echo 0)
            local commit_age=$(git log -1 --format=%ct 2>/dev/null || echo 0)
            if [ $commit_age -gt $readme_age ]; then
                echo "📖 Consider updating README.md - it's older than your latest commits"
            fi
        else
            echo "📖 No README.md found - consider adding project documentation"
        fi
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
