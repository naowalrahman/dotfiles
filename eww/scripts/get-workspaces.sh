#!/bin/bash

# Function to get all active workspaces
get_workspaces() {
    # Get all workspaces from Hyprland
    ACTIVE_WORKSPACES=$(hyprctl workspaces -j | jq -c '.[] | .id')
    ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq '.id')

    # Create an array of all possible workspaces (1-9)
    echo -n "["
    for i in {1..9}; do
        # Check if this workspace is active
        if [ "$i" -eq "$ACTIVE_WORKSPACE" ]; then
            HAS_WINDOWS="\"active\""
        elif echo "$ACTIVE_WORKSPACES" | grep -q "$i"; then
            HAS_WINDOWS="\"windows\""
        else
            HAS_WINDOWS="\"empty\""
        fi

        # Add to JSON array
        echo -n "{\"id\":$i,\"windows\":$HAS_WINDOWS}"

        # Add comma if not the last item
        if [ "$i" -lt 9 ]; then
            echo -n ","
        fi
    done
    echo "]"
}

# Output initial state
get_workspaces

# Listen for changes
socat -u UNIX-CONNECT:/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
    if [[ "$line" == workspace* ]] || [[ "$line" == createworkspace* ]] || [[ "$line" == destroyworkspace* ]]; then
        get_workspaces
    fi
done
