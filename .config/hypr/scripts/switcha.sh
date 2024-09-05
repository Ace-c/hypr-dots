#!/bin/bash


# Function to change Waybar gradient
change_waybar_gradient() {
    local theme="$1"
    local style_file="$HOME/.config/waybar/style.css"
    local new_gradient=""

    case "$theme" in
        "dracula")
            new_gradient="linear-gradient(70deg, rgb(162, 153, 204) 0%, rgb(107, 93, 148) 50%, rgb(82, 54, 137) 100%);"
            ;;
        "gruv")
            new_gradient="linear-gradient(70deg, rgb(167, 185, 129) 0%, rgb(105, 128, 77) 50%, rgb(66, 83, 27) 100%);"
            ;;
        "nord")
            new_gradient="linear-gradient(70deg, rgb(136, 179, 208) 0%, rgb(58, 83, 107) 50%, rgb(43, 55, 66) 100%);"
            ;;
    esac

    if [ -f "$style_file" ]; then
        sed -i "s|linear-gradient(70deg, rgb(162, 153, 204) 0%, rgb(107, 93, 148) 50%, rgb(82, 54, 137) 100%);|$new_gradient|g" "$style_file"
        sed -i "s|linear-gradient(70deg, rgb(167, 185, 129) 0%, rgb(105, 128, 77) 50%, rgb(66, 83, 27) 100%);|$new_gradient|g" "$style_file"
        sed -i "s|linear-gradient(70deg, rgb(136, 179, 208) 0%, rgb(58, 83, 107) 50%, rgb(43, 55, 66) 100%);|$new_gradient|g" "$style_file"
        echo "Changed Waybar gradient"
    else
        echo "Error: Waybar style file not found"
    fi
}

# Function to change VS Code theme
change_vscode_theme() {
    local theme="$1"
    local settings_file="$HOME/.config/Code/User/settings.json"
    local new_theme=""

    case "$theme" in
        "dracula")
            new_theme="Monokai Pro"
            ;;
        "gruv")
            new_theme="Monokai Classic"
            ;;
        "nord")
            new_theme="Nord"
            ;;
    esac

    if [ -f "$settings_file" ]; then
        sed -i "s/\"workbench.colorTheme\": \"[^\"]*\"/\"workbench.colorTheme\": \"$new_theme\"/" "$settings_file"
        echo "Changed VS Code theme to $new_theme"
    else
        echo "Error: VS Code settings file not found"
    fi
}

# Function to change both Waybar gradient and VS Code theme
change_gradient_and_vscode() {
    local theme="$1"
    change_waybar_gradient "$theme"
    change_vscode_theme "$theme"
    # Ensure all changes are written and applied
    sync
    echo "Waybar gradient and VS Code theme changes have been applied and written to disk."
}

# Check command line argument
case "$1" in
    -d|--dracula)
        change_gradient_and_vscode "dracula"
        ;;
    -g|--gruv)
        change_gradient_and_vscode "gruv"
        ;;
    -n|--nord)
        change_gradient_and_vscode "nord"
        ;;
    *)
        echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
        exit 1
        ;;
esac