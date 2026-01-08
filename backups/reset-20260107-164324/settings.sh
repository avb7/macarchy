#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      MACARCHY SETTINGS                                    ║
# ║                                                                           ║
# ║  Centralized configuration for all modules.                               ║
# ║  Edit this file, then run: macarchy apply                                 ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ─────────────────────────────────────────────────────────────────────────────
# ENABLED MODULES
# Set to "true" to enable, "false" to disable
# ─────────────────────────────────────────────────────────────────────────────

export MODULE_AEROSPACE="true"
export MODULE_SKETCHYBAR="true"
export MODULE_BORDERS="true"

# ─────────────────────────────────────────────────────────────────────────────
# WINDOW GAPS (AeroSpace)
# ─────────────────────────────────────────────────────────────────────────────

export GAP_INNER_H="10"          # Horizontal gap between windows
export GAP_INNER_V="10"          # Vertical gap between windows
export GAP_OUTER_LEFT="15"       # Gap from left screen edge
export GAP_OUTER_RIGHT="15"      # Gap from right screen edge
export GAP_OUTER_BOTTOM="15"     # Gap from bottom
export GAP_OUTER_TOP="60"        # Gap from top (space for bar)

# ─────────────────────────────────────────────────────────────────────────────
# BAR (SketchyBar)
# ─────────────────────────────────────────────────────────────────────────────

export BAR_HEIGHT="40"           # Bar height in pixels
export BAR_POSITION="top"        # top or bottom
export BAR_MARGIN="10"           # Margin from screen edges
export BAR_Y_OFFSET="10"         # Vertical offset
export BAR_CORNER_RADIUS="9"     # Corner radius
export BAR_PADDING="10"          # Internal padding
export BAR_BLUR_RADIUS="20"      # Popup blur

# ─────────────────────────────────────────────────────────────────────────────
# WINDOW BORDERS
# ─────────────────────────────────────────────────────────────────────────────

export BORDER_WIDTH="5.0"        # Border thickness (pixels)
export BORDER_STYLE="round"      # round, square, or uniform
export BORDER_HIDPI="on"         # HiDPI support
export BORDER_BLACKLIST=""       # Apps without borders (comma-separated)

# ─────────────────────────────────────────────────────────────────────────────
# TYPOGRAPHY
# ─────────────────────────────────────────────────────────────────────────────

export FONT="SF Pro"             # Main font
export FONT_MONO="SF Mono"       # Monospace font
export FONT_SIZE_ICON="14.0"     # Icon font size
export FONT_SIZE_LABEL="13.0"    # Label font size

# ─────────────────────────────────────────────────────────────────────────────
# KEYBIND MODIFIER
# ─────────────────────────────────────────────────────────────────────────────

export MOD_KEY="alt"             # Primary modifier (alt, cmd, ctrl)

# ─────────────────────────────────────────────────────────────────────────────
# STARTUP
# ─────────────────────────────────────────────────────────────────────────────

export START_AT_LOGIN="false"    # Start Macarchy at login


