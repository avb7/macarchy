#!/bin/bash

MACARCHY_BIN="$HOME/.macarchy/bin/macarchy"

# Flash the icon to show it's working
sketchybar --set reload icon.color=0xff00ff00

if [[ -x "$MACARCHY_BIN" ]]; then
    # Apply and reload macarchy
    "$MACARCHY_BIN" apply &
fi

