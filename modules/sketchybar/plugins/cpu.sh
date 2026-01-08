#!/bin/bash

CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')

sketchybar --set $NAME label="$CPU_USAGE%"
