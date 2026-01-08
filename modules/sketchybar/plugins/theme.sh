#!/bin/bash

THEME_NAME="$1"
MACARCHY_BIN="$HOME/.macarchy/bin/macarchy"

if [[ -n "$THEME_NAME" ]] && [[ -x "$MACARCHY_BIN" ]]; then
    # Apply the theme using macarchy CLI
    "$MACARCHY_BIN" theme "$THEME_NAME" &
fi

