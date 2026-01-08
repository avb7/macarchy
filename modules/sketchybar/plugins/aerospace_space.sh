#!/usr/bin/env bash

# Get the workspace ID passed as argument
WORKSPACE_ID=$1

# Get the currently focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Check if this workspace is the focused one
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar -m --set $NAME background.color=0xff81a1c1
else
  sketchybar -m --set $NAME background.color=0xff57627A
fi

