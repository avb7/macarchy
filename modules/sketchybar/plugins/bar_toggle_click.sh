#!/bin/bash

# Toggle file to track state
TOGGLE_FILE="/tmp/sketchybar_bg_toggle"

# Check current state
if [ -f "$TOGGLE_FILE" ]; then
  # Background is OFF, turn it ON
  rm "$TOGGLE_FILE"
  sketchybar --bar color=0xff0a0a0a border_width=2
  sketchybar --set bar_toggle icon="💡"
else
  # Background is ON, turn it OFF
  touch "$TOGGLE_FILE"
  sketchybar --bar color=0x00000000 border_width=0
  sketchybar --set bar_toggle icon="🌙"
fi

