#!/bin/bash

# Obsidian config file location
OBSIDIAN_CONFIG="$HOME/Documents/Obsidian Vault/.obsidian/appearance.json"

# Okular themes file location
OKULAR_THEME_DIR="$HOME/.config/okular-theme"
OKULAR_SYMLINK_FILE="$HOME/.config/okularpartrc"

# Logseq theme file location
LOGSEQ_THEME_DIR="$HOME/.config/logseq-themes"
LOGSEQ_SYMLINK_FILE="$HOME/.logseq/plugins/logseq-flow-nord-theme/nord.css"


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

# Function to change the Logseq theme
change_logseq_theme() {
    local theme="$1"
    local theme_file="$LOGSEQ_THEME_DIR/${theme}.css"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$LOGSEQ_SYMLINK_FILE"
        echo "change logseq theme to $theme"
    else
        echo "Error: Logseq theme file $theme_file not found"
        fi
}

# Function to change all themes
change_all_themes() {
    local obsidian_theme="$1"
    local okular_theme="$2"
    local logseq_theme="$3"

    change_obsidian_theme "$obsidian_theme"
    change_okular_theme "$okular_theme"
    change_logseq_theme "$logseq_theme"


    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "Dracula Gemini" "dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "Obsidian gruvbox" "gruv" "gruv"
        ;;
    -n|--nord)
        change_all_themes "Nordic" "nord" "nord"
        ;;
    -e|--everforest)
        change_all_themes "Everforest" "everforest" "everforest"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest]"
        exit 1
        ;;
esac

