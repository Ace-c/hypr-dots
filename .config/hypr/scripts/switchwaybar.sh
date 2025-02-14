#!/bin/bash

WAYBAR_CONFIG="$HOME/.config/waybar"
STYLE_DIR="$HOME/.config/Waybar-Style"
STYLE1="$STYLE_DIR/style1/waybar"
STYLE2="$STYLE_DIR/style2/waybar"
WAYBAR_COLOR_DIR="$HOME/.config/waybar/colors"
WAYBAR_COLORS_SYMLINK="$HOME/.config/waybar/colors.css"
WALL_CTL="$HOME/.config/swww/wall.ctl"

# Kill existing waybar instance
kill_waybar() {
    killall waybar 2>/dev/null
    sleep 0.5
}

# Get current theme from wall.ctl
get_current_theme() {
    if [ -f "$WALL_CTL" ]; then
        theme=$(grep "source-file" "$WALL_CTL" | cut -d'|' -f2)
        echo "$theme"
    else
        echo "Error: wall.ctl not found"
        exit 1
    fi
}

# Create color symlink based on theme
setup_color_theme() {
    local theme=$1
    local color_file="$WAYBAR_COLOR_DIR/${theme}.css"
    
    # Check if the color file exists
    if [ -f "$color_file" ]; then
        # Remove existing symlink if it exists
        rm -f "$WAYBAR_COLORS_SYMLINK"
        # Create new symlink
        ln -s "$color_file" "$WAYBAR_COLORS_SYMLINK"
        echo "Linked color theme: $theme"
    else
        echo "Warning: Color file for theme '$theme' not found"
    fi
}

# Function to switch waybar style
switch_waybar() {
    local style=$1
    
    # Kill existing waybar
    kill_waybar
    
    # Remove existing waybar directory
    rm -rf "$WAYBAR_CONFIG"
    
    # Copy the selected style to .config
    cp -r "$style" "$WAYBAR_CONFIG"
    
    # Get and setup current theme colors
    local current_theme=$(get_current_theme)
    setup_color_theme "$current_theme"
    
    # Start waybar
    waybar >/dev/null 2>&1 & disown
    echo "Switched to $(basename $(dirname $style)) with theme $current_theme"
}

# Main script logic
case "$1" in
    "-h")
        switch_waybar "$STYLE1"
        ;;
    "-v")
        switch_waybar "$STYLE2"
        ;;
    *)
        echo "Usage: $0 [-v|-h]"
        echo " -v: Switch to vertical style (style1)"
        echo " -h: Switch to horizontal style (style2)"
        exit 1
        ;;
esac