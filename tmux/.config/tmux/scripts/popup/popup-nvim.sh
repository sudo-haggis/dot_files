#!/usr/bin/env bash
# pop up nvim session intise tmux
#
# usage popup-nvim.sh
# will add alias to bash_alias_tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$1" ]]; then
    echo "Usage: popup-nvim.sh <filename> in TMUX"
    exit 1
fi

FILE="$1"

"$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "nvim '$FILE'"

