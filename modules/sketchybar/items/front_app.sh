#!/bin/bash

front_app=(
  label.font="$FONT:Black:12.0"
  icon.background.drawing=on
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  icon.background.image.scale=0.8
)

sketchybar --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched

