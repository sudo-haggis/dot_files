#!/usr/bin/env bash
# popup/popup-lazygit.sh
# Open lazygit in a tmux popup for the current directory
# Usage: popup-lazygit.sh  (or alias: lg)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "lazygit"
