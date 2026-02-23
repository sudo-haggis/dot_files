#!/usr/bin/env bash
# popup/popup-nav.sh
# Navigate filesystem with ranger, return selected file
# Usage: nvim $(tpop_nav)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULT_FILE="/tmp/tmux-popup-nav-$$"

START_DIR="${1:-.}"

# Clean up old result
rm -f "$RESULT_FILE"

# Run ranger with --choosefile to save selection
"$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" \
    "ranger --choosefile=$RESULT_FILE '$START_DIR'"

# Output the result (or empty if cancelled)
if [[ -f "$RESULT_FILE" ]] && [[ -s "$RESULT_FILE" ]]; then
    cat -e "$RESULT_FILE"
    rm -f "$RESULT_FILE"
fi
