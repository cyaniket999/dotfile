#!/bin/sh

# 1. Check official Pacman updates
# checkupdates is part of the 'pacman-contrib' package
if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

# 2. Check AUR updates
# -Qum specifically lists installed AUR packages that are foreign to the sync DB
if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l); then
    updates_aur=0
fi

# 3. Sum them up
updates=$((updates_arch + updates_aur))

# 4. Output logic
if [ "$updates" -gt 0 ]; then
    # This prints the icon and the total count
    echo "󰏕 $updates"
else
    # Prints nothing when system is up to date
    echo "󰄬" 
fi