#!/bin/bash


# Rofi theme files
ROFI_THEME_DIR="$HOME/.config/rofi/themes"
ROFI_THEME_SYMLINK="$HOME/.config/rofi/themes/theme.rasi"

# Kvantum config file
KVANTUM_THEME_DIR="$HOME/.config/Kvantum/themes"
KVANTUM_THEME_SYMLINK="$HOME/.config/Kvantum/kvantum.kvconfig"

#Wlogout theme files
WLOGOUT_THEME_DIR="$HOME/.config/wlogout/colors"
WLOGOUT_THEME_SYMLINK="$HOME/.config/wlogout/colors/theme.css"

# Kitty theme files
KITTY_THEME_DIR="$HOME/.config/kitty/themes"
KITTY_THEME_SYMLINK="$HOME/.config/kitty/themes/theme.conf"

#Swaylock theme files
SWAYLOCK_THEME_DIR="$HOME/.config/swaylock/themes"
SWAYLOCK_THEME_SYMLINK="$HOME/.config/swaylock/config"


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

# Function to change the Kvantum theme
change_kvantum_theme() {
    local theme="$1"
    local theme_file="$KVANTUM_THEME_DIR/${theme}.kvconfig"
    echo "Changing Kvantum theme to $theme"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$KVANTUM_THEME_SYMLINK"
        echo "Symlink created for Kvantum: $theme_file -> $KVANTUM_THEME_SYMLINK"
        wait
    else
        echo "Error: Kvantum theme file $theme_file not found"
    fi
}

# Function to change the Rofi theme
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

# Function to change the Kitty theme
change_kitty_theme() {
    local theme="$1"
    local theme_file="$KITTY_THEME_DIR/${theme}.conf"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$KITTY_THEME_SYMLINK"
        echo "Changed Kitty theme to $theme"
        killall -SIGUSR2 kitty
    else
        echo "Error: Kitty theme file $theme_file not found"
    fi
}

#Function to change the Swaylock theme
change_swaylock_theme() {
    local theme="$1"
    local theme_file="$SWAYLOCK_THEME_DIR/${theme}.conf"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$SWAYLOCK_THEME_SYMLINK"
        echo "Changed swaylock theme to $theme"
    else
        echo "Error: swaylock theme file $theme_file not found"
    fi
}


# Function to change all themes
change_all_themes() {
    local rofi_theme="$1"
    local kvantum_theme="$2"
    local wlogout_theme="$3"
    local kitty_theme="$4"
    local swaylock_theme="$5"

    change_rofi_theme "$rofi_theme"
    change_kvantum_theme "$kvantum_theme"
    change_wlogout_theme "$wlogout_theme"
    change_kitty_theme "$kitty_theme"
    change_swaylock_theme "$swaylock_theme"

    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "dracula" "Dracula" "dracula" "Dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruv" "Gruv" "gruv" "Gruv" "gruv"
        ;;
    -n|--nord)
        change_all_themes "nord" "Nord" "nord" "Nord" "nord"
        ;; 
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
        exit 1
        ;;
esac