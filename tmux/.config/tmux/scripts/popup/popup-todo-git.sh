#!/usr/bin/env bash
# popup/popup-todo-git.sh
# Split popup: toDoIt (left) | GTree git log (right)
# Usage: popup-todo-git.sh  (or alias: dash)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INNER_CMD="tmux -L popup new-session \
    'toDoIt 2>/dev/null || echo \"toDoIt not found\"; read -p \"Press enter...\"' \; \
    split-window -h \
    'bash -i -c \"GTree 2>/dev/null || echo GTree not found; read -p \\\"Press enter...\\\"\"'"

"$SCRIPT_DIR/../tmux-popup.sh" "$INNER_CMD"
