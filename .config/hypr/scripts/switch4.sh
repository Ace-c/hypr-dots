#!/bin/bash

# Location theme files for Waybar
WAYBAR_COLOR_DIR="$HOME/.config/waybar/colors"
WAYBAR_COLORS_SYMLINK="$HOME/.config/waybar/colors.css"


# Function to change VS Code theme
change_vscode_theme() {
    local theme="$1"
    local settings_file="$HOME/.config/Code/User/settings.json"
    local new_theme=""

    case "$theme" in
        "dracula")
            new_theme="Dracula Clean"
            ;;
        "gruv")
            new_theme="Gruvbox Dark Medium"
            ;;
        "nord")
            new_theme="Nord"
            ;;
        "everforest")
            new_theme="Everforest Dark"
            ;;
        "everblush")
            new_theme="Everblush"
            ;;
    esac

    if [ -f "$settings_file" ]; then
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$new_theme\"/" "$settings_file"
        echo "Changed VS Code theme to $new_theme"
    else
        echo "Error: VS Code settings file not found"
    fi
}

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

# Function to change all themes
change_all_themes() {
    local vscode_theme="$1"
    local waybar_theme="$2"

    change_vscode_theme "$vscode_theme"
    change_waybar_theme "$waybar_theme"
    

    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


case "$1" in
    -d|--dracula)
        change_all_themes "dracula" "dracula"
        ;;
    -g|--gruv)
        change_all_themes "gruv" "gruv" 
        ;;
    -n|--nord)
        change_all_themes "nord" "nord"
        ;;
    -e|--everforest)
        change_all_themes "everforest" "everforest"
        ;;
    -b|--everblush)
        change_all_themes "everblush" "everblush"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
        exit 1
        ;;
esac
