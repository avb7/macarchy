#!/bin/bash

brew=(
  update_freq=120
  icon=􀐛
  icon.font="$FONT:Bold:12.0"
  label.font="$FONT:Semibold:12.0"
  script="$PLUGIN_DIR/brew.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  click_script="brew update && brew upgrade && brew cleanup"
)

sketchybar --add item brew right      \
           --set brew "${brew[@]}"

