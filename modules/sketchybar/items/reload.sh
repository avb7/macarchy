#!/bin/bash

source "$CONFIG_DIR/colors.sh"

reload=(
    icon=􀅈
    icon.font="$FONT:Bold:14.0"
    icon.color=$ACCENT
    icon.padding_left=8
    icon.padding_right=8
    label.drawing=off
    padding_left=2
    padding_right=5
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    click_script="$PLUGIN_DIR/reload.sh"
)

sketchybar --add item reload right \
           --set reload "${reload[@]}"

