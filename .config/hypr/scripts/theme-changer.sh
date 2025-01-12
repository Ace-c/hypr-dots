#!/bin/bash

declare -A THEMES=(
    ["󰺹   Dracula"]="~/.config/hypr/scripts/switchmaster.sh -d"
    ["󱄆   Nord"]="~/.config/hypr/scripts/switchmaster.sh -n"
    ["󱁕   Everforest"]="~/.config/hypr/scripts/switchmaster.sh -e"
    ["   Gruvbox"]="~/.config/hypr/scripts/switchmaster.sh -g"
  
)

theme_names=$(printf "%s\n" "${!THEMES[@]}")
selected=$(echo -e "$theme_names" | rofi -dmenu -i -p "Select Theme")
if [ -n "$selected" ]; then
    command="${THEMES[$selected]}"
    
    if [ -n "$command" ]; then
        eval "$command"
        notify-send "Theme Changed" "Switched to $selected theme"
    fi
fi
