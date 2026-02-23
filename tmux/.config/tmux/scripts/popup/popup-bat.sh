#!/usr/bin/env bash
# popup/popup-bat.sh
# View file with syntax highlighting in a tmux popup
# Usage: popup-bat.sh <filename>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$1" ]]; then
    echo "Usage: popup-bat.sh <filename>"
    exit 1
fi

FILE="$1"

"$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "bat --paging=always '$FILE'"
