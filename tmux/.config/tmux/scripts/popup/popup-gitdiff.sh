#!/usr/bin/env bash
# pop up nvim diff
#
# usage popup-nvim.sh
# will add alias to bash_alias_tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# if no params then remind of the ways of the doing!
if [[ -z "$1" ]]; then
    echo "Usage: popup-gitdiff.sh <filename> <branch1> <branch2> in TMUX"
    exit 1
fi

#If the second param is a file, and there is only 2 params;
# it must be a comparrison of two ranom files situation
if [[ -f "$2" ]] && (( $# == 2 )); then
    FILE1="$1"
    FILE2="$2"

    "$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "nvim -d $FILE1 $FILE2"
fi

#must be a single file and two branches sorta thing !
if [[ -f "$1" ]] && [[ ! -z "$2" ]] && [[ ! -z "$3" ]]; then
    FILE="$1"
    BRANCH1="$2"
    BRANCH2="$3"

    "$SCRIPT_DIR/../tmux-popup.sh" -d "$(pwd)" "nvim -d <(git show $BRANCH1:$FILE) <(git show $BRANCH2:$FILE)"
fi
