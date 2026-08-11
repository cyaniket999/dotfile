#!/bin/sh

# 1. Background Services
killall lxqt-policykit-agent polkit-gnome-authentication-agent-1 2>/dev/null
if [ -x /usr/lib/lxqt-policykit/lxqt-policykit-agent ]; then
    /usr/lib/lxqt-policykit/lxqt-policykit-agent &
elif [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

[ -f ~/.fehbg ] && ~/.fehbg &
killall picom 2>/dev/null; picom &
killall dunst 2>/dev/null; dunst &

# 2. Status Bar Loop
while true; do
    BLUETOOTH=$(~/.config/suckless/dwm_bluetooth.sh)
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

# 3. Launch dwm
exec dwm