#!/bin/bash

# Check for brew updates
UPDATES=$(brew outdated | wc -l | tr -d ' ')

if [ "$UPDATES" = "0" ]; then
  sketchybar --set $NAME drawing=off
else
  sketchybar --set $NAME drawing=on label="$UPDATES"
fi

