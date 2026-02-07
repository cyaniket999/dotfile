#!/usr/bin/env bash

# Options with high-res Nerd Font icons
shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'

# Rofi Command - We pass a custom theme string to create the grid
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | \
		rofi -dmenu \
			 -p "System" \
			 -theme ~/.config/rofi/powermenu.rasi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		systemctl poweroff ;;
    $reboot)
		systemctl reboot ;;
    $lock)
		betterlockscreen -l ;;
    $suspend)
		mpc -q pause; amixer set Master mute; systemctl suspend ;;
    $logout)
		bspc quit ;;
esac