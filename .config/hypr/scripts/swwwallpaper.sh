#!/bin/bash

# Integrated switch3 script function to change wall dir in this one, To change wall with specific theme just run this cmmd 
# ./swwwallpaper.sh -t nord -n [t- assign theme "nord", n- next wallpaper]

set -x

# Initialize lock mechanism to prevent multiple instances
lockFile="/tmp/wallpapers_$(id -u)_swwwallpaper.lock"

cleanup() {
    rm -f "$lockFile"
    echo "Script completed. Lock file removed."
}

if [ -e "$lockFile" ]; then
    pid=$(cat "$lockFile")
    if kill -0 "$pid" 2>/dev/null; then
        echo "Error: An instance of the wallpaper script is already running (PID: $pid)."
        exit 1
    else
        rm -f "$lockFile"
    fi
fi

echo $$ > "$lockFile"
trap cleanup EXIT

# Define core functions for wallpaper management
Wall_Update() {
    local x_wall="$1"
    local theme_name="$2"
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/swww/$theme_name"
    
    # Create cache directory if it doesn't exist
    mkdir -p "$cache_dir"
    
    local cacheImg=$(basename "$x_wall")
    
    # Generate cached versions of the wallpaper
    if [ ! -f "${cache_dir}/${cacheImg}.thumb" ]; then
        magick "${x_wall}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${cache_dir}/${cacheImg}.thumb" &
    fi

    if [ ! -f "${cache_dir}/${cacheImg}.rofi" ]; then
        magick "${x_wall}"[0] -strip -resize 2000 -gravity center -extent 2000 -quality 90 "${cache_dir}/${cacheImg}.rofi" &
    fi

    if [ ! -f "${cache_dir}/${cacheImg}.blur" ]; then
        magick "${x_wall}"[0] -strip -scale 10% -blur 0x3 -resize 100% "${cache_dir}/${cacheImg}.blur" &
    fi

    wait

    # Update wallpaper control file
    echo "source-file|${theme_name}|${x_wall}" > "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.ctl"
    
    # Create symlinks for active wallpaper
    ln -fs "${x_wall}" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set"
    ln -fs "${cache_dir}/${cacheImg}.rofi" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.rofi"
    ln -fs "${cache_dir}/${cacheImg}.blur" "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.blur"
}

Wall_Change() {
    local x_switch=$1
    local theme_dir=$2
    
    # Get list of wallpapers in theme directory
    mapfile -d '' Wallist < <(find "${theme_dir}" -type f \( -iname "*.gif" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z)
    
    # Find current wallpaper index
    local current_wall=$(readlink "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set")
    local current_index=0
    
    for (( i=0; i<${#Wallist[@]}; i++ )); do
        if [ "${Wallist[i]}" == "${current_wall}" ]; then
            current_index=$i
            break
        fi
    done
    
    # Calculate next wallpaper index
    if [ "$x_switch" == "n" ]; then
        nextIndex=$(( (current_index + 1) % ${#Wallist[@]} ))
    elif [ "$x_switch" == "p" ]; then
        nextIndex=$(( (current_index - 1 + ${#Wallist[@]}) % ${#Wallist[@]} ))
    fi
    
    # Update wallpaper
    Wall_Update "${Wallist[nextIndex]}" "$(basename "$theme_dir")"
}

Wall_Set() {
    local transition=${1:-grow}
    
    swww img "$(readlink "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.set")" \
        --transition-bezier .43,1.19,1,.4 \
        --transition-type "$transition" \
        --transition-duration 0.7 \
        --transition-fps 60 \
        --invert-y \
        --transition-pos "$( hyprctl cursorpos )"
}

# Handle different theme directories
WALLPAPER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/swww"
declare -A THEME_DIRS=(
    ["dracula"]="$WALLPAPER_DIR/dracula"
    ["gruv"]="$WALLPAPER_DIR/gruv"
    ["nord"]="$WALLPAPER_DIR/nord"
    ["everforest"]="$WALLPAPER_DIR/everforest"
    ["everblush"]="$WALLPAPER_DIR/everblush"
)

# Parse command line options
while getopts "t:nps:" option; do
    case $option in
        t) # Set theme
            theme_name=$OPTARG
            if [ -n "${THEME_DIRS[$theme_name]}" ]; then
                theme_dir="${THEME_DIRS[$theme_name]}"
                wallpaper=$(find "$theme_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) | head -n 1)
                [ -n "$wallpaper" ] && Wall_Update "$wallpaper" "$theme_name"
            else
                echo "Unknown theme: $theme_name"
                exit 1
            fi
            ;;
        n) # Next wallpaper
            current_theme=$(grep '^source-file|' "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.ctl" | cut -d'|' -f2)
            [ -n "$current_theme" ] && Wall_Change "n" "${THEME_DIRS[$current_theme]}"
            ;;
        p) # Previous wallpaper
            current_theme=$(grep '^source-file|' "${XDG_CONFIG_HOME:-$HOME/.config}/swww/wall.ctl" | cut -d'|' -f2)
            [ -n "$current_theme" ] && Wall_Change "p" "${THEME_DIRS[$current_theme]}"
            ;;
        s) # Set specific wallpaper
            if [ -f "$OPTARG" ]; then
                theme_name=$(basename "$(dirname "$OPTARG")")
                Wall_Update "$OPTARG" "$theme_name"
            fi
            ;;
        *)
            echo "Usage: $0 [-t theme] [-n] [-p] [-s wallpaper]"
            echo "Available themes: ${!THEME_DIRS[@]}"
            exit 1
            ;;
    esac
done

# Initialize swww if needed
swww query || swww init

# Set the wallpaper
Wall_Set