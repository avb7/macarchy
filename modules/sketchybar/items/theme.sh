#!/bin/bash

source "$CONFIG_DIR/colors.sh"

POPUP_OFF="sketchybar --set theme popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

# Get list of available themes
MACARCHY_DIR="$HOME/.macarchy"
THEMES_DIR="$MACARCHY_DIR/themes"
CURRENT_THEME_FILE="$MACARCHY_DIR/config/theme.sh"

# Get current theme name by checking which theme file matches
get_current_theme() {
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        for theme_file in "$THEMES_DIR"/*.sh; do
            theme_name=$(basename "$theme_file" .sh)
            if diff -q "$theme_file" "$CURRENT_THEME_FILE" > /dev/null 2>&1; then
                echo "$theme_name"
                return
            fi
        done
    fi
    echo "unknown"
}

CURRENT_THEME=$(get_current_theme)

theme=(
    icon=􀎑
    icon.font="$FONT:Bold:14.0"
    icon.color=$ACCENT
    icon.padding_left=8
    icon.padding_right=8
    label.drawing=off
    padding_left=5
    padding_right=2
    background.color=$BACKGROUND_1
    background.border_color=$BACKGROUND_2
    click_script="$POPUP_CLICK_SCRIPT"
)

sketchybar --add item theme right \
           --set theme "${theme[@]}"

# Add theme options to popup
theme_index=0
for theme_file in "$THEMES_DIR"/*.sh; do
    theme_name=$(basename "$theme_file" .sh)
    
    # Determine if this is the active theme
    if [[ "$theme_name" == "$CURRENT_THEME" ]]; then
        THEME_ICON="􀁣"  # Checkmark for active
        THEME_COLOR=$ACCENT
    else
        THEME_ICON="􀀀"  # Empty circle
        THEME_COLOR=$LABEL_COLOR
    fi
    
    sketchybar --add item "theme.option.$theme_index" popup.theme \
               --set "theme.option.$theme_index" \
                     icon="$THEME_ICON" \
                     icon.color="$THEME_COLOR" \
                     icon.font="$FONT:Bold:12.0" \
                     icon.padding_left=8 \
                     label="$theme_name" \
                     label.font="$FONT:Regular:12.0" \
                     label.color="$LABEL_COLOR" \
                     label.padding_right=12 \
                     background.color=$POPUP_BACKGROUND_COLOR \
                     background.corner_radius=0 \
                     background.height=28 \
                     click_script="$PLUGIN_DIR/theme.sh '$theme_name'; $POPUP_OFF"
    
    ((theme_index++))
done

