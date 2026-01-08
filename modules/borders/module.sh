#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       BORDERS MODULE                                      ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

MODULE_NAME="borders"
MODULE_DESCRIPTION="Window border highlighting"
MODULE_PROCESS="borders"
MODULE_BREW_PACKAGE="FelixKratz/formulae/borders"
MODULE_BREW_TYPE="formula"

# ─────────────────────────────────────────────────────────────────────────────
# MODULE INTERFACE
# ─────────────────────────────────────────────────────────────────────────────

module_is_installed() {
    brew list borders &>/dev/null
}

module_is_running() {
    pgrep -x "borders" >/dev/null 2>&1
}

module_install() {
    brew tap FelixKratz/formulae 2>/dev/null || true
    brew install borders
}

module_start() {
    if ! module_is_running; then
        source "$MACARCHY_DIR/config/theme.sh"
        source "$MACARCHY_DIR/config/settings.sh"
        
        local cmd="borders active_color=$ACCENT inactive_color=$ACCENT_DIM width=$BORDER_WIDTH"
        [[ -n "$BORDER_STYLE" ]] && cmd="$cmd style=$BORDER_STYLE"
        [[ -n "$BORDER_BLACKLIST" ]] && cmd="$cmd blacklist=\"$BORDER_BLACKLIST\""
        
        eval "$cmd" &
        disown 2>/dev/null || true
    fi
}

module_stop() {
    killall borders 2>/dev/null || true
}

module_reload() {
    module_stop
    sleep 0.3
    module_start
}

module_link() {
    # Borders doesn't need symlinks - it's started with args
    return 0
}

module_unlink() {
    return 0
}

module_apply_theme() {
    # Theme is applied on start via command args
    # If running, restart to apply new theme
    if module_is_running; then
        module_reload
    fi
}

module_status() {
    if module_is_running; then
        echo "running"
    else
        echo "stopped"
    fi
}

module_version() {
    borders --version 2>/dev/null || echo "not installed"
}


