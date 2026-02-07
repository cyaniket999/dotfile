#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
# This prevents the new bar from trying to start while the old one is still closing
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar on every connected monitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    # This sets an environment variable 'MONITOR' that Polybar can read
    MONITOR=$m polybar --reload main 2>&1 | tee -a /tmp/polybar.log & disown
  done
else
  polybar --reload main 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Bars launched..."