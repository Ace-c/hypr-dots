#!/usr/bin/env bash

# Check release
if [ ! -f /etc/arch-release ] ; then
    exit 0
fi

# Check for updates
aur=$(yay -Qua | wc -l)
ofc=`checkupdates | wc -l`

# Calculate total available updates
upd=$(( ofc + aur ))

# Format upd as two digits
upd_formatted=$(printf "%02d" $upd)

# Show tooltip
if [ $upd -eq 0 ] ; then
    echo "{\"text\":\"$upd_formatted\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"$upd_formatted\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur$fpk_disp\"}"
fi

