#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Get wifi SSID using ipconfig (most reliable on modern macOS)
get_wifi_ssid() {
    # Method 1: Use ipconfig to check if wifi interface has an IP (connected)
    # Then get SSID from system_profiler
    local wifi_info=$(system_profiler SPAirPortDataType 2>/dev/null)
    local ssid=$(echo "$wifi_info" | grep -A1 "Current Network Information:" | tail -1 | sed 's/^[[:space:]]*//' | sed 's/:$//')
    
    if [[ -n "$ssid" && "$ssid" != "Current Network Information:" ]]; then
        echo "$ssid"
        return
    fi
    
    # Method 2: Check via ipconfig for active wifi
    local wifi_ip=$(ipconfig getifaddr en0 2>/dev/null)
    if [[ -n "$wifi_ip" ]]; then
        # We have an IP, try to get SSID via defaults
        local ssid2=$(defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences RememberedNetworks 2>/dev/null | grep -m1 SSIDString | sed 's/.*= "\(.*\)";/\1/')
        if [[ -n "$ssid2" ]]; then
            echo "$ssid2"
            return
        fi
        echo "Connected"
        return
    fi
    
    echo ""
}

# Check if wifi is powered on
is_wifi_on() {
    local power=$(networksetup -getairportpower en0 2>/dev/null | grep -i "on")
    [[ -n "$power" ]]
}

# Main logic
if ! is_wifi_on; then
    sketchybar --set $NAME icon="􀙈" icon.color=$GREY
    exit 0
fi

SSID=$(get_wifi_ssid)

if [[ -n "$SSID" ]]; then
    # Connected - show wifi icon with accent color
    sketchybar --set $NAME icon="􀙇" icon.color=$ACCENT
else
    # Wifi on but not connected
    sketchybar --set $NAME icon="􀙈" icon.color=$GREY
fi

