#!/bin/bash

# Mode toggle for Desktop/Laptop layouts
mode_toggle=(
  icon=D
  icon.font="$FONT:Bold:14.0"
  padding_left=5
  padding_right=10
  label.drawing=off
  script="$PLUGIN_DIR/mode_toggle.sh"
  click_script="$PLUGIN_DIR/mode_toggle_click.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item mode_toggle right      \
           --set mode_toggle "${mode_toggle[@]}"

