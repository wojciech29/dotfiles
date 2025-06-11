#!/usr/bin/env bash

options=(
    "home               $HOME/"
    "htop               $HOME/"

    "meteo-ssh          $HOME/"
    "meteo-scratches    $HOME/work/scratches/meteo/"
    "meteo-meteosource  $HOME/work/meteosource/"
    "meteo-crons        $HOME/work/crontab-secure/"
    "meteo-grib2hdf     $HOME/work/grib2hdf/"
    "meteo-nowcasting   $HOME/work/nowcasting/"

    "tz-ssh             $HOME/"
    "tz-scratches       $HOME/work/scratches/tz/"
    "tz-erp             $HOME/work/erp/"
    "tz-tardis          $HOME/work/tardis/"
    "tz-ansible         $HOME/work/devops/ansible/"
    "tz-iris            $HOME/work/iris/"

    "scratches          $HOME/work/scratches/"
    "dotfiles           $HOME/dotfiles/"
    "private            $HOME/private/"
)

# Get the selected option (either from fzf or directly from the argument)
if [[ -z "$1" ]]; then
    selected_option=$(printf "%s\n" "${options[@]}" | awk '{print $1}' | fzf --reverse --no-info)

    [[ -z "$selected_option" ]] && exit 0  # Exit if no option is selected
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
selected_entry_array=($selected_entry)
session_name="${selected_entry_array[0]}"
session_path=$(eval echo "${selected_entry_array[1]}")  # Resolve tilde (~)

# Create a new tmux session if it doesn't exist
tmux new-session -ds "$session_name" -c "$session_path" 2>/dev/null

# Switch to the selected tmux session
tmux switch-client -t "$session_name"

# If the selected session is 'htop', run htop interactively
if [[ "$session_name" == "htop" ]]; then
    if ! tmux list-panes -t "$session_name" -F "#{pane_current_command}" | grep -q "htop"; then
        tmux send-keys -t "$session_name" "htop" C-m
    fi
fi
