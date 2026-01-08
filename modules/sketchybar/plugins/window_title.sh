#!/bin/bash

# Get the front app name using Aerospace
WINDOW_TITLE=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)

# Fallback to AppleScript if Aerospace doesn't return anything
if [ -z "$WINDOW_TITLE" ]; then
  WINDOW_TITLE=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

# Default to "Desktop" if nothing is found
if [ -z "$WINDOW_TITLE" ]; then
  WINDOW_TITLE="Desktop"
fi

sketchybar --set $NAME label="$WINDOW_TITLE"
