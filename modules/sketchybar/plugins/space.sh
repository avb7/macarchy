#!/bin/bash

# Get the space ID from the item name (space.1 -> 1)
SPACE_ID="${NAME#*.}"

# Get current workspace from Aerospace or from event
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE"
else
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# Update colors based on whether this is the focused workspace
if [ "$SPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.border_color=0xffe1e3e4
else
  sketchybar --set $NAME background.border_color=0xff494d64
fi

# Get windows in this workspace
WINDOWS=$(aerospace list-windows --workspace "$SPACE_ID" --format "%{app-name}" 2>/dev/null | head -n 3)

if [ "$WINDOWS" != "" ]; then
  # Show app names as label (truncated)
  LABEL=$(echo "$WINDOWS" | tr '\n' ' ' | sed 's/ $//' | cut -c 1-30)
  sketchybar --set $NAME label="$LABEL"
else
  sketchybar --set $NAME label=""
fi
