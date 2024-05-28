#!/usr/bin/env bash

options=(
    "home       ~/"
    "erp        ~/work/erp/"
    "tardis     ~/work/tardis/"
    "scratches  ~/work/scratches/"
    "ansible    ~/work/devops/ansible/"
    "iris       ~/work/iris/"
    "private    ~/private/"
    "dotfiles   ~/dotfiles/"
    "music      ~/Music/"
)

# Get the selected option (either from fzf or directly from the argument)
if [[ -z "$1" ]]; then
    selected_option=$(printf "%s\n" "${options[@]}" | awk '{print $1}' | fzf --reverse --no-info)

    # Exit if no directory was selected
    [[ -z "$selected_option" ]] && exit 0
else
    selected_option="$1"
fi

# Find the corresponding entry in the options array
for option in "${options[@]}"; do
    if [[ $option == $selected_option* ]]; then
        selected_entry=$option
        break
    fi
done

# Extract the session name and path from the selected entry
session_name=$(echo "$selected_entry" | awk '{print $1}')
session_path=$(echo "$selected_entry" | awk '{print $2}')

# Create a new tmux session if it doesn't exist
tmux new-session -ds "$session_name" -c "$session_path" 2>/dev/null

# Switch to the selected tmux session
tmux switch-client -t "$session_name"
