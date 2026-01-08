#!/bin/bash

# SketchyBar wrapper that monitors Aerospace
# This script starts SketchyBar and monitors if Aerospace is running
# When Aerospace quits, SketchyBar will also quit

# Start SketchyBar
sketchybar &
SKETCHYBAR_PID=$!

# Monitor Aerospace process
while true; do
    if ! pgrep -x "AeroSpace" > /dev/null; then
        # Aerospace is not running, kill SketchyBar
        kill $SKETCHYBAR_PID 2>/dev/null
        exit 0
    fi
    sleep 5
done

