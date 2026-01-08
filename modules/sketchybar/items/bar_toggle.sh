#!/bin/bash

bar_toggle=(
  icon=💡
  icon.font="$FONT:Bold:14.0"
  padding_left=5
  padding_right=10
  label.drawing=off
  script="$PLUGIN_DIR/bar_toggle.sh"
  click_script="$PLUGIN_DIR/bar_toggle_click.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
)

sketchybar --add item bar_toggle right      \
           --set bar_toggle "${bar_toggle[@]}"

