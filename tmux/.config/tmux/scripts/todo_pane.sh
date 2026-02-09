#!/usr/bin/env bash
# tmux-reminder-popup-test.sh
# Test script for floating popup reminder view
# Shows: toDoIt (left) | GTr git tree (right)

set -euo pipefail

# Check we're in tmux
if [[ -z "${TMUX:-}" ]]; then
    echo "Error: This script must be run inside a tmux session"
    exit 1
fi

# Just open a popup with tmux running inside
# The key: use a fresh isolated tmux server with -L flag
# toDoIt = regular command in PATH
# GTr = alias, needs 'bash -i' to load .bashrc
tmux display-popup -E -w 90% -h 90% \
    "tmux -L popup new-session \
        'toDoIt 2>/dev/null || echo toDoIt not found; read -p \"Press enter to close...\"' \; \
        split-window -h \
        'bash -i -c \"GTree 2>/dev/null || echo GTree alias not found; read -p \\\"Press enter to close...\\\"\"'"
