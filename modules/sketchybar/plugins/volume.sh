#!/bin/bash

# Get the volume level
VOLUME=$(osascript -e "output volume of (get volume settings)")

case ${VOLUME} in
  100|9[0-9]|8[0-9]|7[0-9]|6[0-9]) ICON="􀊨"
    ;;
  [5-9]|[1-5][0-9]) ICON="􀊧"
    ;;
  [1-9]) ICON="􀊦"
    ;;
  *) ICON="􀊤"
  esac

sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
