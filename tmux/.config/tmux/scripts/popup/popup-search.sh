#!/usr/bin/env bash
# popup/popup-search.sh
# Search file contents with ripgrep+fzf in popup
# Returns: filepath:line for piping to other commands
# Usage: nvim $(tpop_search "search term")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULT_FILE="/tmp/tmux-popup-search-$$"

QUERY="${1:-}"
SEARCH_DIR="$(pwd)"  # Capture current directory BEFORE popup

# Clean up old result
rm -f "$RESULT_FILE"

# Run rgfzf in popup, extract filepath:line from result
"$SCRIPT_DIR/../tmux-popup.sh" -d "$SEARCH_DIR" \
    "result=\$(rgfzf '$QUERY' '.'); echo \"\$result\" | cut -d: -f1,2 > $RESULT_FILE; exit 0"

# Output the result (or empty if cancelled)
if [[ -f "$RESULT_FILE" ]] && [[ -s "$RESULT_FILE" ]]; then
    SELECTED=$(cat "$RESULT_FILE")
    FILE=$(echo "$SELECTED" | cut -d: -f1)
    LINE=$(echo "$SELECTED" | cut -d: -f2)

    # Strip ./ prefix and build absolute path
    FILE="${FILE#./}"
    printf "%s" "$SEARCH_DIR/$FILE:$LINE"
    rm -f "$RESULT_FILE" "${RESULT_FILE}.out"
fi
