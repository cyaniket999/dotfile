#!/bin/sh

# 1. Remap Caps Lock to act as your Shift key workaround
xmodmap -e "keycode 66 = Shift_L Caps_Lock"

# 2. Restore your last-set feh wallpaper instantly
   if [ -f ~/.fehbg ]; then
       sh ~/.fehbg &
   fi

# 3. Source the system-wide xinitrc.d scripts (handles system paths and tools)
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Background status bar loop
while true; do

    BLUETOOTH=$(~/.local/bin/dwm_bluetooth.sh)
    
    MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    
    # Get Battery Info
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
        BATT=$(cat /sys/class/power_supply/BAT0/capacity)%
    elif [ -f /sys/class/power_supply/BAT1/capacity ]; then
        BATT=$(cat /sys/class/power_supply/BAT1/capacity)%
    else
        BATT="N/A"
    fi
    
    # Get Volume Info from PipeWire/Wireplumber
    VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)"%"}')
    # If muted, append a label
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "[MUTED]"; then
        VOL="MUTED"
    fi
    
    # Get Current Date and Time 
    CLK=$(date +"%d-%m-%y %I:%M %p")

    # Get Wi-Fi Network Name and Signal Strength
    WIFI_INFO=$(nmcli -t -f active,ssid,bars,signal dev wifi | grep '^yes')
    if [ -n "$WIFI_INFO" ]; then
        WIFI_NAME=$(echo "$WIFI_INFO" | cut -d: -f2)
        WIFI_SIG=$(echo "$WIFI_INFO" | cut -d: -f4)
        WIFI="$WIFI_NAME ($WIFI_SIG%)"
    else
        WIFI="Disconnected"
    fi
    
    
    # Set the dwm bar text
    xsetroot -name " $BLUETOOTH | $WIFI | Vol: $VOL | RAM: $MEM | Bat: $BATT | $CLK "
    
    sleep 0.5
done &

# 4. Fire up dwm
exec dwm
