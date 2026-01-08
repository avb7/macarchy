#!/bin/bash

# Get current date and time
DATE=$(date '+%a %d %b')
TIME=$(date '+%H:%M')

sketchybar --set $NAME label="$DATE $TIME"

