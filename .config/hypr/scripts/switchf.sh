#!/bin/bash

# Correct NvChad config file location
NVIM_CONFIG="$HOME/.config/nvim/lua/chadrc.lua"

# Cava themes file location
CAVA_THEME_DIR="$HOME/.config/cava/themes"
CAVA_SYMLINK_FILE="$HOME/.config/cava/config"

FIREFOX_THEME_DIR="$HOME/.config/Firefox-Theme"
FIREFOX_SYMLINK_FILE="$HOME/.mozilla/firefox/b2tf0ph7.default-release/chrome/theme/colors/dark.css"


# Function to change the Neovim theme
change_neovim_theme() {
    local theme="$1"
    if [ -f "$NVIM_CONFIG" ]; then
        sed -i "s/theme = \"[^\"]*\"/theme = \"$theme\"/" "$NVIM_CONFIG"
        echo "Changed Neovim theme to $theme"
        
        # Reload highlights
        nvim --headless -c "lua require('base46').load_all_highlights()" -c q
        
        echo "Reloaded all highlights"
    else
        echo "Error: Neovim config file $NVIM_CONFIG not found"
    fi
}

# Function to change the Cava theme
change_cava_theme() {
    local theme="$1"
    local theme_file="$CAVA_THEME_DIR/${theme}"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$CAVA_SYMLINK_FILE"
        echo "change cava theme to $theme"
    else
        echo "Error: Cava theme file $theme_file not found"
    fi
}

# Function to change the Firefox theme
change_firefox_theme() {
    local theme="$1"
    local theme_file="$FIREFOX_THEME_DIR/${theme}.css"
    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$FIREFOX_SYMLINK_FILE"
        echo "Changed firefox theme to $theme"
    
    else
        echo "Error: firefox theme file $theme_file not found"
    fi
}


# Function to change all themes
change_all_themes() {
    local neovim_theme="$1"
    local cava_theme="$2"
    local firefox_theme="$3"

    change_neovim_theme "$neovim_theme"
    change_cava_theme "$cava_theme"
    change_firefox_theme "$firefox_theme"


    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "chadracula" "dracula" "Dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruvbox" "gruv" "Gruv"
        ;;
    -n|--nord)
        change_all_themes "nord" "nord" "Nord"
        ;;
    -e|--everforest)
        change_all_themes "everforest" "everforest" "Everforest"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest]"
        exit 1
        ;;
esac

