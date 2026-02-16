#!/bin/bash
#run list of ecetutable scripts on start up 
# TODO: need to ensure this script run on start up always
# TODO: need to dynamialyly fuind the screen device number, or thow a pop up asking for it! 
#
#1. map-touchscreens.sh - for zen touch as second touch

SCRIPT_DIR="$HOME/.scripts"
STARTUP_SCRIPTS=(
    "map-touchscreens.sh"
    "swap_caps_n_esc.sh"
    #add more scripts here
)

results=""

if [[ -d "$SCRIPT_DIR" ]]; then
    for script_name in "${STARTUP_SCRIPTS[@]}"; do
        script_path="$SCRIPT_DIR/$script_name"

        if [[ -f "$script_path" && -x "$script_path" ]]; then
            output=$("$script_path" 2>&1)
            exit_code=$? #last exit code

            if [[ $exit_code -eq 0 ]]; then
                results+="$script_name - $output\n"
            else
                results+="$script_name - FAILED: $output\n"
            fi
        fi
    done
fi

echo -e "$results" # testing

cat > /tmp/startup-display.sh << EOF
#!/bin/bash
echo "Start up scripts report for ya cap'n"
echo "===================================="
echo ""
echo -e "$results"
echo ""
read -n1 -p "Press any key to close... or 'i' to interact with the helm" key
if [[ "\$key" == "i" ]]; then
    cd $SCRIPT_DIR && exec bash
fi
EOF

chmod +x /tmp/startup-display.sh

# Try preferred terminal, fall back to available ones
if command -v alacritty &>/dev/null; then
    alacritty -e /tmp/startup-display.sh &
elif command -v gnome-terminal &>/dev/null; then
    gnome-terminal -- /tmp/startup-display.sh &
else
    xterm -e /tmp/startup-display.sh &  # Last resort
fi
