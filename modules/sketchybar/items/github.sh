#!/bin/bash

github=(
  update_freq=180
  icon=$BELL
  icon.font="$FONT:Bold:12.0"
  label.font="$FONT:Semibold:12.0"
  script="$PLUGIN_DIR/github.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  click_script="open https://github.com/notifications"
)

sketchybar --add item github right      \
           --set github "${github[@]}"

