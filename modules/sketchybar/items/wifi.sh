#!/bin/bash

source "$CONFIG_DIR/colors.sh"

wifi=(
    padding_left=5
    padding_right=5
    icon=􀙇
    icon.font="$FONT:Bold:14.0"
    icon.color=$ICON_COLOR
    icon.padding_left=8
    icon.padding_right=8
    label.drawing=off
    script="$PLUGIN_DIR/wifi.sh"
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'"
)

sketchybar --add item wifi right      \
           --set wifi "${wifi[@]}"    \
           --subscribe wifi wifi_change system_woke

