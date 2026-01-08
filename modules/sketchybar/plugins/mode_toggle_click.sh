#!/bin/bash

# Mode file to track current mode
MODE_FILE="$HOME/.config/sketchybar/.mode"

# Read current mode
if [ -f "$MODE_FILE" ]; then
  CURRENT_MODE=$(cat "$MODE_FILE")
else
  CURRENT_MODE="desktop"
fi

# Toggle mode
if [ "$CURRENT_MODE" = "desktop" ]; then
  # Switch to Laptop mode
  NEW_MODE="laptop"
  ICON="L"
  OUTER_GAPS=15  # Equal moderate padding on all sides
  
  # Make bar completely transparent
  sketchybar --bar color=0x00000000 shadow=off border_width=0 margin=10 y_offset=10
  
  # Remove background from all items
  sketchybar --set '/.*/' background.drawing=off
  
else
  # Switch to Desktop mode
  NEW_MODE="desktop"
  ICON="D"
  OUTER_GAPS_TOP=60      # More padding on top only
  OUTER_GAPS_SIDES=15    # Normal padding on other sides
  
  # Restore bar background
  sketchybar --bar color=0xff0a0a0a shadow=on border_width=2 margin=10 y_offset=10
  
  # Restore background for all items
  sketchybar --set '/.*/' background.drawing=on
fi

# Save new mode
echo "$NEW_MODE" > "$MODE_FILE"

# Update icon
sketchybar --set mode_toggle icon="$ICON"

# Update Aerospace config gaps
AEROSPACE_CONFIG="$HOME/.aerospace.toml"
if [ "$NEW_MODE" = "laptop" ]; then
  # Set equal gaps for laptop mode
  sed -i '' "s/outer.left.*=.*/outer.left =       $OUTER_GAPS/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.bottom.*=.*/outer.bottom =     $OUTER_GAPS/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.top.*=.*/outer.top    = $OUTER_GAPS/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.right.*=.*/outer.right =      $OUTER_GAPS/" "$AEROSPACE_CONFIG"
else
  # Set desktop mode gaps (more top padding only)
  sed -i '' "s/outer.left.*=.*/outer.left =       $OUTER_GAPS_SIDES/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.bottom.*=.*/outer.bottom =     $OUTER_GAPS_SIDES/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.top.*=.*/outer.top    = $OUTER_GAPS_TOP/" "$AEROSPACE_CONFIG"
  sed -i '' "s/outer.right.*=.*/outer.right =      $OUTER_GAPS_SIDES/" "$AEROSPACE_CONFIG"
fi

# Reload Aerospace to apply changes
aerospace reload-config

# Optional: Show notification
osascript -e "display notification \"Switched to $NEW_MODE mode\" with title \"Mode Toggle\""

