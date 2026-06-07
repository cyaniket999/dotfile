#!/bin/sh

# 1. If Bluetooth service is completely stopped, show Off
if ! systemctl is-active --quiet bluetooth; then
    echo "BT: Off"
    exit 0
fi

# 2. If the radio is powered down, show Off
if bluetoothctl show | grep -q "Powered: no"; then
    echo "BT: Off"
    exit 0
fi

# 3. Check for any active connection
CONNECTED_MAC=$(bluetoothctl devices Connected | awk '{print $2}' | head -n 1)

# 4. Display logic based on connection status
if [ ! -z "$CONNECTED_MAC" ]; then
    # Grab the connected device's real name dynamically
    DEVICE_NAME=$(bluetoothctl info "$CONNECTED_MAC" | grep "Name:" | cut -d' ' -f2-)
    
    # Extract battery percentage if available
    BATTERY_VAL=$(bluetoothctl info "$CONNECTED_MAC" | grep "Battery Percentage" | awk -F '[()]' '{print $2}')
    
    if [ ! -z "$BATTERY_VAL" ]; then
        echo "$DEVICE_NAME ($BATTERY_VAL%)"
    else
        echo "$DEVICE_NAME"
    fi
else
    # Bluetooth is on and ready, but nothing is connected right now
    echo "BT: On"
fi
