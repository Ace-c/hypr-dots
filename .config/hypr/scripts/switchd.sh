#!/bin/bash

# Set a known working directory
cd "$HOME" || exit 1

# Configuration files
QT5CT_CONFIG="$HOME/.config/qt5ct/qt5ct.conf"
QT6CT_CONFIG="$HOME/.config/qt6ct/qt6ct.conf"
GTK4_TARGET="$HOME/.config/gtk-4.0"

# Function to change Qt5 Icons
change_qt5_icon() {
    local icon_theme="$1"
    sed -i "/^icon_theme=/c\icon_theme=${icon_theme}" "$QT5CT_CONFIG"
    echo "Changed icon theme to $icon_theme"
}

# Function to change Qt5 theme 
change_qt5_theme() {
    local theme="$1"
    sed -i "/^color_scheme_path=/c\color_scheme_path=/$HOME/.config/qt5ct/colors/${theme}.conf" "$QT5CT_CONFIG"
    echo "Changed Qt5 theme to $theme"
}

# Function to change Qt6 Icons
change_qt6_icon() {
    local icon_theme="$1"
    sed -i "/^icon_theme=/c\icon_theme=${icon_theme}" "$QT6CT_CONFIG"
    echo "Changed Qt6 icon theme to $icon_theme"
}

#Function to change Qt6 theme
change_qt6_theme() {
    local theme="$1"
    sed -i "/^color_scheme_path=/c\color_scheme_path=/$HOME/.config/qt5ct/colors/${theme}.conf" "$QT6CT_CONFIG"
    echo "Changed Qt6 theme to $theme"
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
    local icon_theme="$1"
    local icon_theme="$2"
    local gtk4_theme="$3"
    local qt5_theme="$4"
    local qt6_theme="$5"
    
    change_qt5_icon "$icon_theme"
    change_qt6_icon "$icon_theme"
    change_gtk4_theme "$gtk4_theme"
    change_qt5_theme "$qt5_theme"
    change_qt6_theme "$qt6_theme"
    
    echo "All Qt and GTK4 theme changes have been applied."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_all_themes "Tela-circle-dracula" "Tela-circle-dracula" "Dracula" "Dracula" "Dracula"
        ;;
    -g|--gruv)
        change_all_themes "Tela-circle-gruv" "Tela-circle-gruv" "Gruvbox" "Gruv" "Gruv"
        ;;
    -n|--nord)
        change_all_themes "Tela-circle-nord" "Tela-circle-nord" "Nord" "Nord" "Nord"
        ;;
    -e|--everforest)
        change_all_themes "Nordzy-turquoise-dark" "Nordzy-turquoise-dark" "Everforest" "Everforest" "Everforest"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest]"
        exit 1
        ;;
esac