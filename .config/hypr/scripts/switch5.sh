#!/bin/bash


# Rofi theme files
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
ROFI_THEME_SYMLINK="$HOME/.config/rofi/themes/theme.rasi"

#Wlogout theme files
WLOGOUT_THEME_DIR="$HOME/.config/wlogout/colors"
WLOGOUT_THEME_SYMLINK="$HOME/.config/wlogout/colors/theme.css"

# Dunst config file
DUNST_CONFIG_FILE="$HOME/.config/dunst/dunstrc"
DUNST_THEME_DIR="$HOME/.config/dunst/themes"



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


# Function to change the wlogout theme
change_wlogout_theme() {
    local theme="$1"
    local theme_file="$WLOGOUT_THEME_DIR/${theme}.css"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$WLOGOUT_THEME_SYMLINK"
        echo "Changed wlogout theme to $theme"
    else
        echo "Error: wlogout theme file $theme_file not found"
    fi
}


# Function to change the Dunst theme
change_dunst_theme() {
    local theme="$1"
    local theme_file="$DUNST_THEME_DIR/$theme"
    if [ -f "$DUNST_CONFIG_FILE" ] && [ -f "$theme_file" ]; then
        sed -i '345,$d' "$DUNST_CONFIG_FILE"
        cat "$theme_file" >> "$DUNST_CONFIG_FILE"
        echo "Changed Dunst theme to $theme"
        killall dunst
        dunst &
    else
        echo "Error: Dunst config file or theme file not found"
    fi
}


# Function to change all themes
change_all_themes() {
    local rofi_theme="$1"
    local wlogout_theme="$2"
    local dunst_theme="$3"

    change_rofi_theme "$rofi_theme"
    change_wlogout_theme "$wlogout_theme"
    change_dunst_theme "$dunst_theme"

    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "dracula" "dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruv" "gruv" "gruv"
        ;;
    -n|--nord)
        change_all_themes "nord"  "nord" "nord"
        ;;
    -e|--everforest)
        change_all_themes "everforest" "everforest" "everforest" 
        ;;
    -b|--everblush)
        change_all_themes "everblush" "everblush" "everblush" 
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
        exit 1
        ;;
esac