#!/bin/bash


# Directory containing the color theme files for Waybar
WAYBAR_COLOR_DIR="$HOME/.config/waybar/colors"
WAYBAR_COLORS_SYMLINK="$HOME/.config/waybar/colors.css"

# Hyprland theme files
HYPR_THEME_DIR="$HOME/.config/hypr/themes"
HYPR_THEME_SYMLINK="$HOME/.config/hypr/themes/theme.conf"

# Rofi theme files
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
ROFI_THEME_SYMLINK="$HOME/.config/rofi/themes/theme.rasi"

# Function to change the Waybar theme
change_waybar_theme() {
    local theme="$1"
    local theme_file="$WAYBAR_COLOR_DIR/${theme}.css"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$WAYBAR_COLORS_SYMLINK"
        echo "Changed Waybar theme to $theme"
        killall -SIGUSR2 waybar
    
    else
        echo "Error: Waybar theme file $theme_file not found"
    fi
}

# Function to change the Hyprland theme
change_hypr_theme() {
    local theme="$1"
    local theme_file="$HYPR_THEME_DIR/${theme}.conf"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$HYPR_THEME_SYMLINK"
        echo "Changed Hyprland theme to $theme"
        hyprctl reload
    else
        echo "Error: Hyprland theme file $theme_file not found"
    fi
}

# Function to change the Rofi theme
change_rofi_theme() {
    local theme="$1"
    local theme_file="$ROFI_THEME_DIR/${theme}.rasi"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$ROFI_THEME_SYMLINK"
        echo "Changed Rofi theme to $theme"
        pkill -x rofi
    else
        echo "Error: Rofi theme file $theme_file not found"
    fi
}


# Function to change all themes
change_all_themes() {
    local waybar_theme="$1"
    local hypr_theme="$2"
    local rofi_theme="$3"

    change_waybar_theme "$waybar_theme"
    change_hypr_theme "$hypr_theme"
    change_rofi_theme "$rofi_theme"


    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "dracula" "Dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruv" "Gruv" "gruv"
        ;;
    -n|--nord)
        change_all_themes "nord" "Nord" "nord"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
        exit 1
        ;;
esac