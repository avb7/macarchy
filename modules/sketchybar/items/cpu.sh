#!/bin/bash

cpu=(
  update_freq=2
  icon=􀧓
  icon.font="$FONT:Bold:12.0"
  icon.color=$BLUE
  padding_left=5
  padding_right=10
  label.font="$FONT:Semibold:12.0"
  label.color=$BLUE
  script="$PLUGIN_DIR/cpu.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item cpu right \
           --set cpu "${cpu[@]}"

