#!/bin/bash

CONFIG_FILE=~/.ssh/zeus

# Check if SSH config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "SSH config file not found: $CONFIG_FILE"
  exit 1
fi

# Read all SSH aliases from the SSH config
SSH_ALIASES=$(grep "^Host " "$CONFIG_FILE" | awk '{print $2}')

# Check if there are any aliases
if [ -z "$SSH_ALIASES" ]; then
  echo "No SSH aliases found in the config file"
  exit 1
fi

# Use fzf to select an SSH alias
SELECTED_ALIAS=$(echo "$SSH_ALIASES" | fzf --prompt="Select SSH alias: ")

# Check if a selection was made
if [ -z "$SELECTED_ALIAS" ]; then
  echo "No alias selected"
  exit 1
fi

# Get the Host entry from the SSH config
SSH_CONFIG_ENTRY=$(awk "/^Host $SELECTED_ALIAS$/{flag=1;next}/^Host /{flag=0}flag" "$CONFIG_FILE")

# Extract the SSH connection details
HOST=$(echo "$SSH_CONFIG_ENTRY" | awk '/HostName/ {print $2}')
USER=$(echo "$SSH_CONFIG_ENTRY" | awk '/User/ {print $2}')
PORT=$(echo "$SSH_CONFIG_ENTRY" | awk '/Port/ {print $2}')
IDENTITY_FILE=$(echo "$SSH_CONFIG_ENTRY" | awk '/IdentityFile/ {print $2}')

# Set default values if they are not found in the config
PORT=${PORT:-22}

# Check if HOST is not empty
if [ -z "$HOST" ]; then
  echo "HostName not found in the config for alias $SELECTED_ALIAS"
  exit 1
fi

SSH_COMMAND="ssh -p $PORT ${IDENTITY_FILE:+-i $IDENTITY_FILE} ${USER:+$USER@}$HOST"

# Create a new tmux session and set default command
tmux new-session -ds "$SELECTED_ALIAS"
tmux set-option -t "$SELECTED_ALIAS" default-command "$SSH_COMMAND"

# Switch to the newly created session
tmux switch-client -t "$SELECTED_ALIAS"
