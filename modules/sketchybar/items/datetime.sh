#!/bin/bash

datetime=(
  update_freq=30
  icon=📅
  icon.font="$FONT:Bold:12.0"
  icon.padding_right=4
  label.font="$FONT:Semibold:12.0"
  padding_left=10
  padding_right=10
  script="$PLUGIN_DIR/datetime.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item datetime right      \
           --set datetime "${datetime[@]}"

