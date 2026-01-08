#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      AEROSPACE MODULE                                     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

MODULE_NAME="aerospace"
MODULE_DESCRIPTION="Tiling window manager"
MODULE_PROCESS="AeroSpace"
MODULE_BREW_PACKAGE="nikitabobko/tap/aerospace"
MODULE_BREW_TYPE="cask"

# ─────────────────────────────────────────────────────────────────────────────
# MODULE INTERFACE
# ─────────────────────────────────────────────────────────────────────────────

module_is_installed() {
    brew list --cask aerospace &>/dev/null
}

module_is_running() {
    pgrep -x "AeroSpace" >/dev/null 2>&1
}

module_install() {
    brew tap nikitabobko/tap 2>/dev/null || true
    brew install --cask aerospace
}

module_start() {
    if ! module_is_running; then
        open -a AeroSpace
        sleep 2
    fi
}

module_stop() {
    killall AeroSpace 2>/dev/null || true
}

module_reload() {
    aerospace reload-config 2>/dev/null || true
}

module_link() {
    local src="$MACARCHY_DIR/modules/aerospace/aerospace.toml"
    local dest="$HOME/.aerospace.toml"
    
    [[ -e "$dest" ]] || [[ -L "$dest" ]] && rm -f "$dest"
    ln -s "$src" "$dest"
}

module_unlink() {
    [[ -L "$HOME/.aerospace.toml" ]] && rm "$HOME/.aerospace.toml"
}

module_apply_theme() {
    local config="$MACARCHY_DIR/modules/aerospace/aerospace.toml"
    
    # Load theme and settings
    source "$MACARCHY_DIR/config/theme.sh"
    source "$MACARCHY_DIR/config/settings.sh"
    
    # Update borders command in aerospace config
    local borders_cmd="borders active_color=$ACCENT inactive_color=$ACCENT_DIM width=$BORDER_WIDTH"
    
    if grep -q "exec-and-forget borders" "$config"; then
        sed -i '' "s|'exec-and-forget borders.*'|'exec-and-forget $borders_cmd'|" "$config"
    fi
    
    # Update inner gaps (match line start with spaces, end at newline)
    sed -i '' "s|^[[:space:]]*inner\.horizontal = .*|    inner.horizontal = ${GAP_INNER_H:-10}|" "$config"
    sed -i '' "s|^[[:space:]]*inner\.vertical = .*|    inner.vertical = ${GAP_INNER_V:-10}|" "$config"
    
    # Update outer gaps (left, right, bottom - simple values)
    sed -i '' "s|^[[:space:]]*outer\.left = .*|    outer.left = ${GAP_OUTER_LEFT:-15}|" "$config"
    sed -i '' "s|^[[:space:]]*outer\.right = .*|    outer.right = ${GAP_OUTER_RIGHT:-15}|" "$config"
    sed -i '' "s|^[[:space:]]*outer\.bottom = .*|    outer.bottom = ${GAP_OUTER_BOTTOM:-15}|" "$config"
    
    # Update top gap with per-monitor support (laptop vs external)
    # Format: [{ monitor.'built-in' = LAPTOP_GAP }, EXTERNAL_GAP]
    local laptop_top="${GAP_OUTER_TOP_LAPTOP:-45}"
    local external_top="${GAP_OUTER_TOP:-60}"
    sed -i '' "s|^[[:space:]]*outer\.top = .*|    outer.top = [{ monitor.'built-in' = ${laptop_top} }, ${external_top}]|" "$config"
}

module_status() {
    if module_is_running; then
        echo "running"
    else
        echo "stopped"
    fi
}

module_version() {
    aerospace --version 2>/dev/null || echo "not installed"
}


