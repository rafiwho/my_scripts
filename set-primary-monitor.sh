#!/bin/bash

# Function to check HDMI connection with retries
check_hdmi_connection() {
    local retries=2
    local delay=3
    for (( i=0; i<retries; i++ )); do
        xrandr | grep -q "HDMI-1-0 connected"
        if [ $? -eq 0 ]; then
            return 0
        fi
        echo "HDMI-1-0 not detected. Retrying in $delay seconds..."
        sleep $delay
    done
    return 1
}

# Check if HDMI-1-0 is connected
if check_hdmi_connection; then
    echo "HDMI-1-0 is connected. Setting it as primary."

    # Set HDMI-1-0 as the primary display
    xrandr --output HDMI-1-0 --primary --mode 1920x1080 --rate 165 --right-of eDP || {
        echo "Failed to set HDMI-1-0 as primary."
        exit 1
    }

    # Turn off the laptop screen
    xrandr --output eDP --off || {
        echo "Failed to turn off the laptop screen."
        exit 1
    }

    # Move all open windows to HDMI-1-0
    while IFS= read -r win_id; do
        wmctrl -i -r "$win_id" -e 0,0,0,-1,-1 || {
            echo "Failed to move window $win_id."
        }
    done < <(wmctrl -l | awk '{print $1}')
else
    echo "HDMI-1-0 is not connected after retries. Attempting to restart GDM."

    # Restart GDM to force redetection of monitors
    sudo systemctl restart gdm || {
        echo "Failed to restart GDM."
        exit 1
    }
fi
