#!/bin/bash
#run list of ecetutable scripts on start up 
# TODO: need to ensure this script run on start up always
# TODO: need to dynamialyly fuind the screen device number, or thow a pop up asking for it! 
#
#1. map-touchscreens.sh - for zen touch as second touch

SCRIPT_DIR="$HOME/.scripts"
STARTUP_SCRIPTS=(
    "map-touchscreens.sh"
    #add more scripts here
)

if [[ -d "$SCRIPT_DIR" ]]; then
    for script_name in "${STARTUP_SCRIPTS[@]}"; do 
        script_path="$SCRIPT_DIR/$script_name"

        if [[ -f "$script_path" && -x "$script_path" ]]; then
            "$script_path"
        fi
    done
fi
