#!/usr/bin/env bash

# Check if one argument is being provided
if [[ $# -eq 1 ]]; then
	# Use the provided argument as the selected directory
	ssh_name=$1
elif [[ $# -eq 0 ]]; then
	# Explicitly specified 0 in case someone decides to pass more than 1 argument
	# Call the ssh-select script which will open fzf to select a host
	~/github/dotfiles-latest/tmux/tools/linkarzu/ssh-select.sh
	# Debugging, uncomment below if you need to see what's being selected
	# tmux display-message -d 10000 "Directory selected via fzf: $ssh_name"
else
	# This will hopefully catch your attention
	tmux display-message -d 500 "This script expects zero or one argument."
	sleep 1
	tmux display-message -d 500 "This script expects zero or one argument."
	sleep 1
	tmux display-message -d 5000 "This script expects zero or one argument."
fi

selected_after_tr=$(basename "$ssh_name" | tr '.-' '__')

selected_name="SSH-$ssh_name"$selected_after_tr

# If a tmux session with the desired name does not already exist, create it in detached mode
if ! tmux has-session -t=$selected_name 2>/dev/null; then
	# I included quotes in "$ssh_name" because wasn't changing to dirs that have a space
	# Like the iCloud dir
	tmux new-session -s "$selected_name" -d "ssh $ssh_name"
fi

# Switch to the tmux session with the name derived from the selected directory
tmux switch-client -t $selected_name
