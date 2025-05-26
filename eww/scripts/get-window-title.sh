#!/bin/bash

# Function to get active window title
get_window_title() {
    TITLE=$(hyprctl activewindow -j | jq -r '.title')
    if [[ "$TITLE" == "null" ]]; then
        echo "Desktop"
    else
        echo "$TITLE"
    fi
}

# Output initial state
get_window_title

# Listen for changes
socat -u UNIX-CONNECT:/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ "$line" == activewindow* ]] || [[ "$line" == openwindow* ]] || [[ "$line" == closewindow* ]]; then
        get_window_title
    fi
done
