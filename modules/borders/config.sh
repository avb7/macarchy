#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        MACARCHY BORDERS CONFIG                            ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Source theme for colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config/theme.sh"

# ─────────────────────────────────────────────────────────────────────────────
# BORDER SETTINGS
# ─────────────────────────────────────────────────────────────────────────────

export BORDER_ACTIVE="$ACCENT"           # Focused window border color
export BORDER_INACTIVE="$ACCENT_DIM"     # Unfocused window border color
export BORDER_WIDTH="${BORDER_WIDTH:-5.0}"
export BORDER_STYLE="round"              # round, square, or uniform

# ─────────────────────────────────────────────────────────────────────────────
# BLACKLIST (apps that won't get borders)
# ─────────────────────────────────────────────────────────────────────────────

export BORDER_BLACKLIST=""  # Comma-separated, e.g., "Safari,Finder"

# ─────────────────────────────────────────────────────────────────────────────
# BUILD COMMAND
# ─────────────────────────────────────────────────────────────────────────────

# This function returns the borders command with all arguments
get_borders_cmd() {
    local cmd="borders active_color=$BORDER_ACTIVE inactive_color=$BORDER_INACTIVE width=$BORDER_WIDTH style=$BORDER_STYLE"
    
    if [[ -n "$BORDER_BLACKLIST" ]]; then
        cmd="$cmd blacklist=\"$BORDER_BLACKLIST\""
    fi
    
    echo "$cmd"
}

