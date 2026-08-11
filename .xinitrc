#!/bin/sh

# 1. Source global configs (runs xmodmap)
[ -f ~/.xprofile ] && . ~/.xprofile

# 2. Session Switcher
case "$WM" in
    openbox)
        exec openbox-session
        ;;
    bspwm)
        sxhkd &
        exec bspwm
        ;;
    xfce)
        exec startxfce4
        ;;
    *)
        # Default session: runs your complete dwm setup script
        exec ~/.config/suckless/startdwm.sh
        ;;
esac