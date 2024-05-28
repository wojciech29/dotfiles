#!/bin/bash

# Output the names of all active network connections

output=$(nmcli -g name,type con show --active | awk -F: '$2 != "bridge" && $2 != "tun" { printf "%s%s", sep, $1; sep = " | " }')

echo "${output:-No connections}"
