#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        MACARCHY UNINSTALLER                               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

set -e

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_RED='\033[31m'
C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_ACCENT='\033[38;5;208m'

msg_info()    { echo -e "  ${C_BOLD}ℹ${C_RESET}  $1"; }
msg_success() { echo -e "  ${C_GREEN}✓${C_RESET}  $1"; }
msg_warn()    { echo -e "  ${C_YELLOW}⚠${C_RESET}  $1"; }

echo ""
echo -e "${C_RED}╔═══════════════════════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_RED}║${C_RESET}              ${C_BOLD}MACARCHY UNINSTALLER${C_RESET}                             ${C_RED}║${C_RESET}"
echo -e "${C_RED}╚═══════════════════════════════════════════════════════════════╝${C_RESET}"
echo ""
echo "  This will:"
echo "    • Stop all Macarchy services"
echo "    • Remove config symlinks"
echo "    • Optionally restore backups"
echo "    • Optionally remove ~/.macarchy"
echo ""

read -r -p "  Continue? [y/N] " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && echo "  Cancelled." && exit 0

echo ""
echo -e "${C_BOLD}Stopping Services${C_RESET}"
killall AeroSpace 2>/dev/null && msg_success "Stopped AeroSpace" || true
killall sketchybar 2>/dev/null && msg_success "Stopped SketchyBar" || true
killall borders 2>/dev/null && msg_success "Stopped Borders" || true

echo ""
echo -e "${C_BOLD}Removing Symlinks${C_RESET}"
[[ -L "$HOME/.aerospace.toml" ]] && rm "$HOME/.aerospace.toml" && msg_success "Removed ~/.aerospace.toml"
[[ -L "$HOME/.config/sketchybar" ]] && rm "$HOME/.config/sketchybar" && msg_success "Removed ~/.config/sketchybar"

# Restore backups
BACKUP_DIR=$(ls -td "$HOME"/.macarchy-backup-* 2>/dev/null | head -1)
if [[ -n "$BACKUP_DIR" ]] && [[ -d "$BACKUP_DIR" ]]; then
    echo ""
    echo -e "  Found backup: ${C_BOLD}$BACKUP_DIR${C_RESET}"
    read -r -p "  Restore original configs? [Y/n] " restore
    restore=${restore:-Y}
    
    if [[ "$restore" =~ ^[Yy]$ ]]; then
        [[ -f "$BACKUP_DIR/aerospace.toml" ]] && cp "$BACKUP_DIR/aerospace.toml" "$HOME/.aerospace.toml" && msg_success "Restored aerospace.toml"
        [[ -d "$BACKUP_DIR/sketchybar" ]] && cp -R "$BACKUP_DIR/sketchybar" "$HOME/.config/sketchybar" && msg_success "Restored sketchybar"
    fi
fi

# Remove login item
echo ""
echo -e "${C_BOLD}Cleaning Up${C_RESET}"
osascript -e 'tell application "System Events" to delete login item "AeroSpace"' 2>/dev/null && msg_success "Removed from login items" || true

# Clean shell config
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
    if [[ -f "$rc" ]] && grep -q "macarchy" "$rc" 2>/dev/null; then
        grep -v "macarchy" "$rc" | grep -v "# Macarchy" > "$rc.tmp" && mv "$rc.tmp" "$rc"
        msg_success "Cleaned $rc"
    fi
done

# Remove directory
if [[ -d "$HOME/.macarchy" ]] || [[ -L "$HOME/.macarchy" ]]; then
    echo ""
    read -r -p "  Remove ~/.macarchy directory? [y/N] " remove_dir
    [[ "$remove_dir" =~ ^[Yy]$ ]] && rm -rf "$HOME/.macarchy" && msg_success "Removed ~/.macarchy"
fi

# Uninstall deps
echo ""
read -r -p "  Uninstall AeroSpace, SketchyBar, Borders? [y/N] " remove_deps
if [[ "$remove_deps" =~ ^[Yy]$ ]]; then
    brew uninstall --cask aerospace 2>/dev/null && msg_success "Uninstalled AeroSpace" || true
    brew uninstall sketchybar 2>/dev/null && msg_success "Uninstalled SketchyBar" || true
    brew uninstall borders 2>/dev/null && msg_success "Uninstalled Borders" || true
fi

echo ""
echo -e "${C_GREEN}✓${C_RESET}  ${C_BOLD}Macarchy uninstalled${C_RESET}"
[[ -n "$BACKUP_DIR" ]] && echo -e "  ${C_DIM}Backup still available at: $BACKUP_DIR${C_RESET}"
echo ""
