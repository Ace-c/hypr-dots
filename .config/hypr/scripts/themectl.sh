#!/bin/bash

# This global theme control script used to use same theming and configuration settings,
# maintaining visual and functional consistency across hyprland.

# wallpaper var
ConfDir="${XDG_CONFIG_HOME:-$HOME/.config}"
WallCtl="$ConfDir/swww/wall.ctl" # Active wallpaper locations written in this file
cacheDir="$HOME/.cache/wallpapers" 

# gtk var
gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`

# hypr var
hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`

