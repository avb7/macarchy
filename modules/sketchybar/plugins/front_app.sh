#!/bin/bash

# Get the front app using Aerospace
APP=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)

# Fallback to AppleScript
if [ -z "$APP" ]; then
  APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

if [ -z "$APP" ]; then
  APP="Finder"
fi

sketchybar --set $NAME label="$APP" icon.background.image="app.$APP"
