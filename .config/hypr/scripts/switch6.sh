#!/bin/bash

# Discord theme file location
DISCORD_THEME_FILE="$HOME/.config/BetterDiscord/data/stable/themes.json"

# btop configuration file location
BTOP_CONFIG_FILE="$HOME/.config/btop/btop.conf"

# Kitty theme files
KITTY_THEME_DIR="$HOME/.config/kitty/themes"
KITTY_THEME_SYMLINK="$HOME/.config/kitty/themes/theme.conf"


# Hyprlock config file
HYPRLOCK_THEME_DIR="$HOME/.config/hypr/hyprlock-themes"
HYPRLOCK_THEME_SYMLINK="$HOME/.config/hypr/hyprlock.conf"

# Function to change the Discord theme
change_discord_theme() {
    local theme_name="$1"
    
    # Backup the original Discord theme file
    cp "$DISCORD_THEME_FILE" "${DISCORD_THEME_FILE}.bak"

    # Update the theme in the JSON file
    jq --arg theme "$theme_name" '. |= with_entries(.value = false) | .[$theme] = true' "$DISCORD_THEME_FILE" > "${DISCORD_THEME_FILE}.tmp" && mv "${DISCORD_THEME_FILE}.tmp" "$DISCORD_THEME_FILE"

    echo "Changed Discord theme to $theme_name"
    
    # Check if Discord is running and reload it
    if pgrep -x "Discord" > /dev/null; then
        xdotool search --onlyvisible --class "discord" windowactivate --sync key ctrl+r
        echo "Discord has been reloaded."
    else
        echo "Discord is not running."
    fi
}

# Function to change the btop theme
change_btop_theme() {
    local theme_name="$1"
    
    # Update the theme in the Btop configuration file
    sed -i "s|^color_theme=.*|color_theme=\"/usr/share/btop/themes/${theme_name}.theme\"|" "$BTOP_CONFIG_FILE"
    echo "Changed btop theme to $theme_name"
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

# Function to change the Hyprlock theme
change_hyprlock_theme() {
    local theme="$1"
    local theme_file="$HYPRLOCK_THEME_DIR/${theme}.conf"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$HYPRLOCK_THEME_SYMLINK"
        echo "Changed Hyprlock theme to $theme"
    else
        echo "Error: Hyprlock theme file $theme_file not found"
    fi
}

# Function to change all themes
change_all_themes() {
    local discord_theme="$1"
    local btop_theme="$2"
    local kitty_theme="$3"
    local hyprlock_theme="$4"

    change_discord_theme "$discord_theme"
    change_btop_theme "$btop_theme"
    change_kitty_theme "$kitty_theme"
    change_hyprlock_theme "$hyprlock_theme"

    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


case "$1" in
    -d|--dracula)
        change_all_themes "dracula" "dracula" "Dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruv" "gruvbox_dark_v2" "Gruv" "gruv"
        ;;
    -n|--nord)
        change_all_themes "nord" "nord" "Nord" "nord"
        ;;
    -e|--everforest)
        change_all_themes "everforest" "everforest-dark-medium" "Everforest" "everforest"
        ;;
    -b|--everblush)
        change_all_themes "everblush" "adapta" "Everblush" "everblush"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
        exit 1
        ;;
esac
