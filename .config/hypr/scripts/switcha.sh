#!/bin/bash


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
            new_theme="Gruvbox Dark Hard"
            ;;
        "nord")
            new_theme="Nord"
            ;;
        "everforest")
            new_theme="Everforest Dark"
            ;;
    esac

    if [ -f "$settings_file" ]; then
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$new_theme\"/" "$settings_file"
        echo "Changed VS Code theme to $new_theme"
    else
        echo "Error: VS Code settings file not found"
    fi
}

# Function to change VS Code theme
change_vscode() {
    local theme="$1"
    change_vscode_theme "$theme"
    # Ensure all changes are written and applied
    sync
    echo "VS Code theme changes have been applied and written to disk."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_vscode "dracula"
        ;;
    -g|--gruv)
        change_vscode "gruv"
        ;;
    -n|--nord)
        change_vscode "nord"
        ;;
    -e|--everforest)
        change_vscode "everforest"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest]"
        exit 1
        ;;
esac