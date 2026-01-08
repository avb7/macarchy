#!/bin/bash

spotify_logo=(
  padding_left=10
  icon=􀑪
  icon.font="$FONT:Heavy:16.0"
  icon.color=$GREEN
  label.drawing=off
  script="$PLUGIN_DIR/spotify.sh"
)

spotify_title=(
  padding_left=0
  padding_right=0
  icon.drawing=off
  label.font="$FONT:Heavy:12.0"
  label.max_chars=20
  label.scroll_duration=100
  y_offset=6
  script="$PLUGIN_DIR/spotify.sh"
)

spotify_artist=(
  padding_left=0
  padding_right=0
  icon.drawing=off
  y_offset=-6
  label.font="$FONT:Heavy:10.0"
  script="$PLUGIN_DIR/spotify.sh"
)

sketchybar --add item spotify.logo center                \
           --set spotify.logo "${spotify_logo[@]}"       \
                                                         \
           --add item spotify.title center               \
           --set spotify.title "${spotify_title[@]}"     \
                                                         \
           --add item spotify.artist center              \
           --set spotify.artist "${spotify_artist[@]}"   \
                                                         \
           --subscribe spotify.logo spotify_change       \
           --subscribe spotify.title spotify_change      \
           --subscribe spotify.artist spotify_change

