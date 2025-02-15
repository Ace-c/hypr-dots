#!/bin/bash


# Hyprland theme files
HYPR_THEME_DIR="$HOME/.config/hypr/themes"
HYPR_THEME_SYMLINK="$HOME/.config/hypr/themes/theme.conf"

# GTK 4 theme location
GTK4_TARGET="$HOME/.config/gtk-4.0"

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

# Function to change GTK4 theme
change_gtk4_theme() {
    local theme="$1"
    local gtk4_source=""
    
    case "$theme" in
        "Nord")
            gtk4_source="/$HOME/.themes/Nordic-darker/gtk-4.0"
            ;;
        "Dracula")
            gtk4_source="/$HOME/.themes/Dracula/gtk-4.0"
            ;;
        "Gruvbox")
            gtk4_source="/$HOME/.themes/Gruvbox-Dark/gtk-4.0"
            ;;
        "Everforest")
            gtk4_source="/$HOME/.themes/Everforest-Dark-Soft/gtk-4.0"
            ;;
        "Everblush")
            gtk4_source="/$HOME/.themes/Everblush/gtk-4.0"
            ;;
        *)
            echo "Error: Unknown theme $theme"
            return 1
            ;;
    esac
    
    if [ -d "$gtk4_source" ]; then
        ln -sfn "$gtk4_source" "$GTK4_TARGET"
        echo "Changed GTK4 theme to $theme"
    else
        echo "Error: GTK4 theme directory $gtk4_source not found"
        return 1
    fi
}

# Function to change all themes
change_all_themes() {
    local hypr_theme="$1"
    local gtk4_theme="$2"

    change_hypr_theme "$hypr_theme"
    change_gtk4_theme "$gtk4_theme"


    # Ensure all changes are written and applied
    sync
    echo "All theme changes have been applied and written to disk."
}


case "$1" in
    -d|--dracula)
        change_all_themes "Dracula" "Dracula"
        ;;
    -g|--gruv)
        change_all_themes "Gruv" "Gruvbox"
        ;;
    -n|--nord)
        change_all_themes "Nord" "Nord"
        ;;
    -e|--everforest)
        change_all_themes "Everforest" "Everforest"
        ;;
    -b|--everblush)
        change_all_themes "Everblush" "Everblush"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
        exit 1
        ;;
esac

# Updating nwg-look(This will update gtk2 and gtk3)
echo "Updating nwg-look..."
nwg-look -x
