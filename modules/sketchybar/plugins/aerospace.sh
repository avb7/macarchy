#!/bin/bash

# Get the workspace ID passed as argument
WORKSPACE_ID=$1

# Get the currently focused workspace from Aerospace
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED_WORKSPACE="$FOCUSED_WORKSPACE"
else
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

# Update the workspace appearance
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on
else
  sketchybar --set $NAME background.drawing=off
fi
