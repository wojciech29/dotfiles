#!/bin/bash

# Rescan WiFi networks
nmcli device wifi rescan > /dev/null

# List available WiFi networks and allow user to select one
ssid=$(nmcli device wifi list | tail -n +2 | grep -v '^\s*--' | fzf -1 -0 | awk '{print $2}')

# Check if a valid SSID was selected
if [ -n "$ssid" ]; then
    # Check if the SSID already has a connection setup
    if nmcli con show | grep -q "$ssid"; then
        echo "Please wait while switching to known network $ssid…"
        # If yes, bring up that connection
        nmcli con up id "$ssid"
    else
        echo "Please wait while connecting to new network $ssid…"
        # If not, connect to it and ask for the password
        nmcli device wifi connect "$ssid"
    fi
else
    echo "No network selected. Exiting."
    exit 1
fi
