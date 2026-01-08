#!/bin/bash

RUNNING=$(osascript -e 'if application "Spotify" is running then return 0')

if [ "$RUNNING" == "" ]; then
  sketchybar --set spotify.logo drawing=off \
             --set spotify.title drawing=off \
             --set spotify.artist drawing=off
  exit 0
fi

PLAYING=$(osascript -e 'tell application "Spotify" to player state')

if [ "$PLAYING" = "playing" ]; then
  TRACK=$(osascript -e 'tell application "Spotify" to name of current track')
  ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track')
  
  sketchybar --set spotify.logo drawing=on \
             --set spotify.title drawing=on label="$TRACK" \
             --set spotify.artist drawing=on label="$ARTIST"
else
  sketchybar --set spotify.logo drawing=off \
             --set spotify.title drawing=off \
             --set spotify.artist drawing=off
fi

