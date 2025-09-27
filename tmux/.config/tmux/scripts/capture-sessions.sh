#!/bin/bash
# capture-sessions.sh - Extract your running tmux sessions into project files
# Save as: ~/.dotfiles/tmux/.config/tmux/scripts/capture-sessions.sh

capture_session_to_project() {
    local session_name="$1"
    local project_dir="$2"
    
    if [ -z "$session_name" ] || [ -z "$project_dir" ]; then
        echo "Usage: capture_session_to_project <session_name> <project_dir>"
        return 1
    fi
    
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        echo "❌ Session '$session_name' not found!"
        return 1
    fi
    
    if [ ! -d "$project_dir" ]; then
        echo "❌ Directory '$project_dir' not found!"
        return 1
    fi
    
    cd "$project_dir"
    
    echo "🔍 Capturing session '$session_name' to $(pwd)..."
    
    # Get session info
    local windows=$(tmux list-windows -t "$session_name" -F "#{window_index}:#{window_name}:#{window_active}")
    
    # Create the layout template
    cat > ".tmux-layout" << EOF
#!/bin/bash
# Auto-generated tmux layout for: $(basename "$project_dir")
# Captured from running session: $session_name
# Created: $(date)

SESSION_NAME="$session_name"
PROJECT_ROOT="\$(pwd)"

# Kill existing session if it exists
tmux kill-session -t "\$SESSION_NAME" 2>/dev/null

echo "🚀 Launching session: \$SESSION_NAME"

# Create main session
tmux new-session -d -s "\$SESSION_NAME" -c "\$PROJECT_ROOT"

EOF

    local first_window=true
    
    # Process each window
    while IFS= read -r window_line; do
        local window_index=$(echo "$window_line" | cut -d: -f1)
        local window_name=$(echo "$window_line" | cut -d: -f2)
        local is_active=$(echo "$window_line" | cut -d: -f3)
        
        echo "  📋 Capturing window $window_index: $window_name"
        
        if [ "$first_window" = true ]; then
            # First window is created with the session
            echo "# Window $window_index: $window_name (main window)" >> ".tmux-layout"
            echo "tmux rename-window -t \"\$SESSION_NAME:$window_index\" \"$window_name\"" >> ".tmux-layout"
            first_window=false
        else
            # Additional windows
            echo "" >> ".tmux-layout"
            echo "# Window $window_index: $window_name" >> ".tmux-layout"
            echo "tmux new-window -t \"\$SESSION_NAME\" -n \"$window_name\" -c \"\$PROJECT_ROOT\"" >> ".tmux-layout"
        fi
        
        # Get panes for this window
        local panes=$(tmux list-panes -t "$session_name:$window_index" -F "#{pane_index}:#{pane_current_path}:#{pane_active}")
        local pane_count=$(echo "$panes" | wc -l)
        
        if [ "$pane_count" -gt 1 ]; then
            echo "    🔲 Found $pane_count panes in window $window_name"
            
            local first_pane=true
            while IFS= read -r pane_line; do
                local pane_index=$(echo "$pane_line" | cut -d: -f1)
                local pane_path=$(echo "$pane_line" | cut -d: -f2)
                local pane_active=$(echo "$pane_line" | cut -d: -f3)
                
                if [ "$first_pane" = false ]; then
                    echo "tmux split-window -t \"\$SESSION_NAME:$window_index\" -c \"$pane_path\"" >> ".tmux-layout"
                fi
                first_pane=false
            done <<< "$panes"
        fi
        
        # Get current working directory of main pane
        local main_pane_path=$(tmux display-message -t "$session_name:$window_index.0" -p "#{pane_current_path}")
        if [ "$main_pane_path" != "$project_dir" ]; then
            echo "tmux send-keys -t \"\$SESSION_NAME:$window_index\" \"cd $main_pane_path\" Enter" >> ".tmux-layout"
        fi
        
        # Add a comment line for user customization
        echo "# tmux send-keys -t \"\$SESSION_NAME:$window_index\" \"your_command_here\" Enter" >> ".tmux-layout"
        
    done <<< "$windows"
    
    # Add session attach at the end
    cat >> ".tmux-layout" << EOF

# Select main window and attach
tmux select-window -t "\$SESSION_NAME:1"
tmux attach-session -t "\$SESSION_NAME"
EOF
    
    chmod +x ".tmux-layout"
    
    echo "✅ Session captured to .tmux-layout"
    echo "📝 Edit the file to add startup commands for each pane"
    
    # Also save current session state using tmux-resurrect
    echo "💾 Also saving current session state..."
    tmux run-shell '~/.config/tmux/plugins/tmux-resurrect/scripts/save.sh'
    
    # Extract just this session from the resurrect file
    local resurrect_dir="$HOME/.config/tmux/resurrect"
    local latest_file=$(ls -t "$resurrect_dir"/tmux_resurrect_*.txt 2>/dev/null | head -1)
    
    if [ -f "$latest_file" ]; then
        grep "$session_name" "$latest_file" > ".tmux-session"
        echo "💾 Session state saved to .tmux-session"
    fi
    
    # Create/update .gitignore
    if [ -f ".gitignore" ]; then
        if ! grep -q ".tmux-session" ".gitignore" 2>/dev/null; then
            echo "" >> .gitignore
            echo "# Tmux session files" >> .gitignore
            echo ".tmux-session" >> .gitignore
            echo "📝 Added .tmux-session to .gitignore"
        fi
    else
        echo ".tmux-session" > .gitignore
        echo "📝 Created .gitignore with .tmux-session"
    fi
    
    echo ""
    echo "🎯 What's been created:"
    echo "  📋 .tmux-layout   - Editable template (commit this!)"
    echo "  💾 .tmux-session  - Current state (auto-ignored)"
    echo "  📝 .gitignore     - Updated"
    echo ""
    echo "🚀 Next steps:"
    echo "  1. Edit .tmux-layout to add startup commands"
    echo "  2. git add .tmux-layout"
    echo "  3. git commit -m 'feat: add tmux session layout'"
}

# Interactive session capture
interactive_capture() {
    echo "🏴‍☠️ Active tmux sessions:"
    tmux list-sessions -F "#{session_name}: #{session_windows} windows, #{session_attached} attached" 2>/dev/null || {
        echo "❌ No tmux sessions found!"
        return 1
    }
    echo ""
    
    echo "📁 Current directory: $(pwd)"
    echo ""
    
    read -p "Enter session name to capture: " session_name
    if [ -z "$session_name" ]; then
        echo "❌ No session name provided"
        return 1
    fi
    
    read -p "Enter project directory (or press Enter for current): " project_dir
    project_dir="${project_dir:-$(pwd)}"
    
    capture_session_to_project "$session_name" "$project_dir"
}

# Batch capture for all sessions
batch_capture() {
    echo "🔄 Batch capturing all sessions..."
    
    local sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    
    if [ -z "$sessions" ]; then
        echo "❌ No tmux sessions found!"
        return 1
    fi
    
    while IFS= read -r session; do
        echo ""
        echo "🎯 Processing session: $session"
        
        # Try to guess project directory based on session name
        local possible_dirs=(
            "$HOME/webDev/$session"
            "$HOME/projects/$session" 
            "$HOME/$session"
            "$(pwd)"
        )
        
        local project_dir=""
        for dir in "${possible_dirs[@]}"; do
            if [ -d "$dir" ]; then
                project_dir="$dir"
                break
            fi
        done
        
        if [ -n "$project_dir" ]; then
            echo "📁 Auto-detected project dir: $project_dir"
            capture_session_to_project "$session" "$project_dir"
        else
            echo "❓ Could not auto-detect project directory for $session"
            read -p "Enter project directory (or 's' to skip): " manual_dir
            
            if [ "$manual_dir" != "s" ] && [ -n "$manual_dir" ] && [ -d "$manual_dir" ]; then
                capture_session_to_project "$session" "$manual_dir"
            else
                echo "⏭️  Skipping $session"
            fi
        fi
    done <<< "$sessions"
}

# Main command dispatcher
case "${1:-interactive}" in
    "capture")
        capture_session_to_project "$2" "$3"
        ;;
    "interactive"|"i")
        interactive_capture
        ;;
    "batch"|"all")
        batch_capture
        ;;
    "list")
        echo "🏴‍☠️ Active tmux sessions:"
        tmux list-sessions 2>/dev/null || echo "❌ No sessions found"
        ;;
    *)
        echo "🔍 Tmux Session Capturer"
        echo ""
        echo "Commands:"
        echo "  interactive (default) - Interactive session capture"
        echo "  capture <session> <dir> - Capture specific session"
        echo "  batch                 - Capture all sessions"
        echo "  list                  - List active sessions"
        echo ""
        echo "Examples:"
        echo "  $0 interactive"
        echo "  $0 capture GASdev ~/webDev/GASdev"
        echo "  $0 batch"
        ;;
esac
