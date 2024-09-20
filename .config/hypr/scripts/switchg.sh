#!/bin/bash

# Obsidian config file location
OBSIDIAN_CONFIG="$HOME/Documents/Obsidian Vault/.obsidian/appearance.json"

# Okular themes file location
OKULAR_THEME_DIR="$HOME/.config/okular-theme"
OKULAR_SYMLINK_FILE="$HOME/.config/okularpartrc"


# Function to change the Obsidian theme
change_obsidian_theme() {
    local theme="$1"
    if [ -f "$OBSIDIAN_CONFIG" ]; then
        sed -i 's/"cssTheme": "[^"]*",/"cssTheme": "'"$theme"'",/' "$OBSIDIAN_CONFIG"
        echo "Changed Obsidian theme to $theme"
    else
        echo "Error: Obsidian config file $OBSIDIAN_CONFIG not found"
    fi
}

# Function to change the Okular theme
change_okular_theme() {
    local theme="$1"
    local theme_file="$OKULAR_THEME_DIR/${theme}"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$OKULAR_SYMLINK_FILE"
        echo "change okular theme to $theme"
    else
        echo "Error: Okular theme file $theme_file not found"
    fi
}


# Function to change all themes
change_all_themes() {
    local obsidian_theme="$1"
    local okular_theme="$2"

    change_obsidian_theme "$obsidian_theme"
    change_okular_theme "$okular_theme"


    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "Dracula Gemini" "dracula" 
        ;;
    -g|--gruv)
        change_all_themes "Obsidian gruvbox" "gruv" 
        ;;
    -n|--nord)
        change_all_themes "Nordic" "nord" 
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
        exit 1
        ;;
esac
