#!/bin/bash

volume=(
  script="$PLUGIN_DIR/volume.sh"
  padding_left=10
  padding_right=10
  icon.padding_left=6
  icon.padding_right=8
  icon.font="$FONT:Regular:16.0"
  label.width=40
  label.padding_left=6
  label.padding_right=6
  label.align=right
  label.font="$FONT:Semibold:13.0"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item volume right      \
           --set volume "${volume[@]}"  \
           --subscribe volume volume_change

