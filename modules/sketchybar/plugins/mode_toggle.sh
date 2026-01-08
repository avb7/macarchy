#!/bin/bash

# Check current mode from file
MODE_FILE="$HOME/.config/sketchybar/.mode"

if [ -f "$MODE_FILE" ]; then
  MODE=$(cat "$MODE_FILE")
else
  MODE="desktop"
  echo "desktop" > "$MODE_FILE"
fi

if [ "$MODE" = "desktop" ]; then
  sketchybar --set $NAME icon="D"
else
  sketchybar --set $NAME icon="L"
fi

