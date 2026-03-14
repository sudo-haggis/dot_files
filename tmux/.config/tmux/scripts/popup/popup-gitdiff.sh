#!/usr/bin/env bash
# pop up nvim diff
#
# usage popup-nvim.sh
# will add alias to bash_alias_tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$1" ]]; then
    echo "Usage: popup-gitdiff.sh <filename> <branch1> <branch2> in TMUX"
    exit 1
fi

FILE="$1"
BRANCH1="$2"
BRANCH2="$3"

"$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "nvim -d <(git show $BRANCH1:$FILE) <(git show $BRANCH2:$FILE)"

