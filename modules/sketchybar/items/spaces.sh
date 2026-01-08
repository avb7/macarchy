#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))

  space=(
    space=$sid
    icon="${SPACE_ICONS[i]}"
    icon.padding_left=7
    icon.padding_right=7
    icon.highlight_color=$RED
    padding_left=2
    padding_right=2
    label.padding_right=20
    label.color=$GREY
    label.highlight_color=$WHITE
    label.font="sketchybar-app-font:Regular:16.0"
    label.y_offset=-1
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    background.border_width=2
    script="$PLUGIN_DIR/space.sh"
    click_script="aerospace workspace $sid"
  )

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid aerospace_workspace_change
done

space_separator=(
  icon=">"
  icon.font="$FONT:Heavy:16.0"
  padding_left=10
  padding_right=15
  label.drawing=off
  associated_display=active
  icon.color=$WHITE
  background.drawing=off
)

sketchybar --add item space_separator left         \
           --set space_separator "${space_separator[@]}"

