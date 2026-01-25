#!/bin/bash
#run list of ecetutable scripts on start up 

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
