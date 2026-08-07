#!/bin/sh

# 1. Remap Caps Lock to act as your Shift key workaround
xmodmap -e "keycode 66 = Shift_L Caps_Lock"

# 2. Restore your last-set feh wallpaper instantly
if [ -f ~/.fehbg ]; then
    sh ~/.fehbg &
fi

# 3. Source the system-wide xinitrc.d scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# 4. Start Polkit Authentication Agent in the background
if [ -x /usr/lib/lxqt-policykit/lxqt-policykit-agent ]; then
    /usr/lib/lxqt-policykit/lxqt-policykit-agent &
elif [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

# 5. Choose window manager based on the DESKTOP variable
if [ "$DESKTOP" = "openbox" ]; then
    exec openbox-session

elif [ "$DESKTOP" = "bspwm" ]; then
    sxhkd &
    exec bspwm

else
    # Default / DWM: Start the status bar loop in the background, then launch dwm
    while true; do
        BLUETOOTH=$(~/.local/bin/dwm_bluetooth.sh)
        MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
        
        if [ -f /sys/class/power_supply/BAT0/capacity ]; then
            BATT=$(cat /sys/class/power_supply/BAT0/capacity)%
        elif [ -f /sys/class/power_supply/BAT1/capacity ]; then
            BATT=$(cat /sys/class/power_supply/BAT1/capacity)%
        else
            BATT="N/A"
        fi
        
        VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)"%"}')
        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "[MUTED]"; then
            VOL="MUTED"
        fi
        
        CLK=$(date +"%d-%m-%y %I:%M %p")
        WIFI_INFO=$(nmcli -t -f active,ssid,bars,signal dev wifi | grep '^yes')
        if [ -n "$WIFI_INFO" ]; then
            WIFI_NAME=$(echo "$WIFI_INFO" | cut -d: -f2)
            WIFI_SIG=$(echo "$WIFI_INFO" | cut -d: -f4)
            WIFI="$WIFI_NAME ($WIFI_SIG%)"
        else
            WIFI="Disconnected"
        fi
        
        xsetroot -name " $BLUETOOTH | $WIFI | Vol: $VOL | RAM: $MEM | Bat: $BATT | $CLK "
        sleep 2
    done &

    exec dwm
fi