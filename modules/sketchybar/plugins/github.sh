#!/bin/bash

# This requires a GitHub personal access token
# Set it in your environment: export GITHUB_TOKEN="your_token_here"

if [ -z "$GITHUB_TOKEN" ]; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

NOTIFICATIONS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/notifications | jq '. | length')

if [ "$NOTIFICATIONS" = "0" ] || [ "$NOTIFICATIONS" = "" ]; then
  sketchybar --set $NAME icon=􀋚 label=""
else
  sketchybar --set $NAME icon=􀝗 label="$NOTIFICATIONS"
fi

