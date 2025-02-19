#!/bin/bash

# Importing wallpaper script
SWWW_SCRIPT="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/swwwallpaper.sh"

# Define wallpaper directories for each theme
WALLPAPER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/swww"
DRACULA_DIR="$WALLPAPER_DIR/dracula"
GRUV_DIR="$WALLPAPER_DIR/gruv"
NORD_DIR="$WALLPAPER_DIR/nord"
EVERFOREST_DIR="$WALLPAPER_DIR/everforest"
EVERBLUSH_DIR="$WALLPAPER_DIR/everblush"

# Function to change wallpaper directory and set a wallpaper
change_wallpaper_theme() {
    local theme_dir="$1"

    if [ ! -d "$theme_dir" ]; then
        echo "Error: Wallpaper directory $theme_dir not found."
        exit 1
    fi

    # Get the first wallpaper in the directory
    local wallpaper=$(find "$theme_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) | head -n 1)

    if [ -z "$wallpaper" ]; then
        echo "Error: No wallpapers found in $theme_dir"
        exit 1
    fi

    # Set the wallpaper using swwwallpaper script
    "$SWWW_SCRIPT" -s "$wallpaper"
}
 

case "$1" in
    -d|--dracula)
        change_wallpaper_theme "$DRACULA_DIR"
        ;;
    -g|--gruv)
        change_wallpaper_theme "$GRUV_DIR"
        ;;
    -n|--nord)
        change_wallpaper_theme "$NORD_DIR"
        ;;
    -e|--everforest)
        change_wallpaper_theme "$EVERFOREST_DIR"
        ;;
    -b|--everblush)
        change_wallpaper_theme "$EVERBLUSH_DIR"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest][-b|--everblush]"
        exit 1
        ;;
esac
