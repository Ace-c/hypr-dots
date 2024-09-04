#!/bin/bash

#"This scripts ensure to use same theming and configuration settings,
#maintaining visual and functional consistency across the desktop environment"

# wallpaper var
ConfDir="${XDG_CONFIG_HOME:-$HOME/.config}"
ThemeCtl="$ConfDir/hypr/theme.ctl" #This files writes active wallpapers location for current active theme
cacheDir="$HOME/.cache/wallpapers" #This is cache folder where diffrent theme wallpaper cache is stored

# gtk var
gtkTheme=`gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g"`
gtkMode=`gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g" | awk -F '-' '{print $2}'`

# hypr var
hypr_border=`hyprctl -j getoption decoration:rounding | jq '.int'`
hypr_width=`hyprctl -j getoption general:border_size | jq '.int'`

