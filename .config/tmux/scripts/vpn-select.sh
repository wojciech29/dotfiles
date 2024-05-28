#!/bin/bash

ALL_OFF="all off"

list_vpns () {
    nmcli -t con show "$@" | grep ':vpn:' | cut -d":" -f1
}

selected_vpn=$(echo -e "$ALL_OFF\n$(list_vpns)" | fzf)

if [ -z "$selected_vpn" ]; then
    echo "Nothing selected"
    exit 1
fi

# Deactivate any active VPNs
list_vpns --active | while read -r active_vpn; do
  if [[ "$selected_vpn" == "$ALL_OFF" || "$selected_vpn" != "$active_vpn" ]]; then
      echo "Deactivating $active_vpn"
      nmcli con down "$active_vpn"
  fi
done

if [[ "$selected_vpn" != "$ALL_OFF" ]]; then
    echo "Activating $selected_vpn"
    if ! nmcli con up "$selected_vpn"; then
        echo "Failed to activate $selected_vpn"
        exit 1
    fi
fi
