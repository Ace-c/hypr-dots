#!/bin/bash

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Set file variables
ScrDir=$(dirname "$(realpath "$0")")
wLayout="${XDG_CONFIG_HOME:-$HOME/.config}/wlogout/layout"
wlTmplt="${XDG_CONFIG_HOME:-$HOME/.config}/wlogout/style.css"

if [ ! -f "$wLayout" ] || [ ! -f "$wlTmplt" ]; then
    echo "ERROR: Config files not found..."
    exit 1
fi

# Define static values for layout based on 1920x1080 resolution
wlColms=6  # Number of columns in wlogout
export mgn=280  # Adjusted margin for 1080p
export hvr=240  # Adjusted hover effect size for 1080p
export fntSize=20  # Adjusted font size for 1080p

# Set default colors (can be customized manually)
export WindBg="rgba(0,0,0,0.5)"

# Define static border radius values
export active_rad=15  # Adjusted border radius for 1080p
export button_rad=20  # Adjusted button border radius for 1080p

# Apply style template
wlStyle=$(envsubst < "$wlTmplt")

# Launch wlogout
wlogout -b "$wlColms" -c 0 -r 0 -m 0 --layout "$wLayout" --css <(echo "$wlStyle") --protocol layer-shell