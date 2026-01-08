#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      SKETCHYBAR MODULE                                    ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

MODULE_NAME="sketchybar"
MODULE_DESCRIPTION="Custom menu bar"
MODULE_PROCESS="sketchybar"
MODULE_BREW_PACKAGE="FelixKratz/formulae/sketchybar"
MODULE_BREW_TYPE="formula"

# ─────────────────────────────────────────────────────────────────────────────
# MODULE INTERFACE
# ─────────────────────────────────────────────────────────────────────────────

module_is_installed() {
    brew list sketchybar &>/dev/null
}

module_is_running() {
    pgrep -x "sketchybar" >/dev/null 2>&1
}

module_install() {
    brew tap FelixKratz/formulae 2>/dev/null || true
    brew install sketchybar
}

module_start() {
    if ! module_is_running; then
        "$MACARCHY_DIR/modules/sketchybar/sketchybar_wrapper.sh" &
        disown 2>/dev/null || true
        sleep 1
    fi
}

module_stop() {
    killall sketchybar 2>/dev/null || true
}

module_reload() {
    module_stop
    sleep 0.5
    module_start
}

module_link() {
    local src="$MACARCHY_DIR/modules/sketchybar"
    local dest="$HOME/.config/sketchybar"
    
    mkdir -p "$HOME/.config"
    [[ -e "$dest" ]] || [[ -L "$dest" ]] && rm -rf "$dest"
    ln -s "$src" "$dest"
}

module_unlink() {
    [[ -L "$HOME/.config/sketchybar" ]] && rm "$HOME/.config/sketchybar"
}

module_apply_theme() {
    source "$MACARCHY_DIR/config/theme.sh"
    source "$MACARCHY_DIR/config/settings.sh"
    
    # Generate colors.sh from theme
    cat > "$MACARCHY_DIR/modules/sketchybar/colors.sh" << EOF
#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  AUTO-GENERATED - DO NOT EDIT                                             ║
# ║  Edit config/theme.sh instead, then run: macarchy apply                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Color Palette
export BLACK=$BLACK
export WHITE=$WHITE
export RED=$RED
export GREEN=$GREEN
export BLUE=$BLUE
export YELLOW=$YELLOW
export ORANGE=$ORANGE
export MAGENTA=$MAGENTA
export GREY=$GREY
export TRANSPARENT=$TRANSPARENT

# Accent colors
export ACCENT=$ACCENT
export ACCENT_DIM=$ACCENT_DIM

# Bar colors
export BAR_COLOR=$BAR_COLOR
export ICON_COLOR=$ICON_COLOR
export LABEL_COLOR=$LABEL_COLOR
export BACKGROUND_1=$BACKGROUND_1
export BACKGROUND_2=$BACKGROUND_2

export POPUP_BACKGROUND_COLOR=$POPUP_BACKGROUND_COLOR
export POPUP_BORDER_COLOR=$POPUP_BORDER_COLOR
export SHADOW_COLOR=$SHADOW_COLOR
EOF
}

module_status() {
    if module_is_running; then
        echo "running"
    else
        echo "stopped"
    fi
}

module_version() {
    sketchybar --version 2>/dev/null || echo "not installed"
}


