#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         MACARCHY INSTALLER                                ║
# ║                 Tiling Desktop Environment for macOS                      ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

set -e

# ─────────────────────────────────────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────

MACARCHY_REPO="https://github.com/YOUR_USERNAME/macarchy.git"
MACARCHY_DIR="$HOME/.macarchy"
BACKUP_DIR="$HOME/.macarchy-backup-$(date +%Y%m%d-%H%M%S)"
MIN_MACOS_VERSION="14.0"

# ─────────────────────────────────────────────────────────────────────────────
# COLORS & STYLING
# ─────────────────────────────────────────────────────────────────────────────

C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_RED='\033[31m'
C_GREEN='\033[32m'
C_YELLOW='\033[33m'
C_BLUE='\033[34m'
C_MAGENTA='\033[35m'
C_ACCENT='\033[38;5;208m'

msg_info()    { echo -e "${C_BLUE}${C_BOLD}ℹ${C_RESET}  $1"; }
msg_success() { echo -e "${C_GREEN}${C_BOLD}✓${C_RESET}  $1"; }
msg_warn()    { echo -e "${C_YELLOW}${C_BOLD}⚠${C_RESET}  $1"; }
msg_error()   { echo -e "${C_RED}${C_BOLD}✗${C_RESET}  $1"; exit 1; }
msg_step()    { echo -e "   ${C_DIM}→${C_RESET} $1"; }

section() {
    echo ""
    echo -e "${C_BOLD}$1${C_RESET}"
    echo -e "${C_DIM}$(printf '%.s─' {1..50})${C_RESET}"
}

# ─────────────────────────────────────────────────────────────────────────────
# ASCII BANNER
# ─────────────────────────────────────────────────────────────────────────────

print_banner() {
    echo ""
    echo -e "${C_ACCENT}    __  ___                           __         ${C_RESET}"
    echo -e "${C_ACCENT}   /  |/  /___ __________ ___________/ /_  __  __${C_RESET}"
    echo -e "${C_ACCENT}  / /|_/ / __ \`/ ___/ __ \`/ ___/ ___/ __ \\/ / / /${C_RESET}"
    echo -e "${C_ACCENT} / /  / / /_/ / /__/ /_/ / /  / /__/ / / / /_/ / ${C_RESET}"
    echo -e "${C_ACCENT}/_/  /_/\\__,_/\\___/\\__,_/_/   \\___/_/ /_/\\__, /  ${C_RESET}"
    echo -e "${C_ACCENT}                                        /____/   ${C_RESET}"
    echo ""
    echo -e "${C_DIM}           Tiling Desktop Environment Installer${C_RESET}"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# PREFLIGHT CHECKS
# ─────────────────────────────────────────────────────────────────────────────

check_macos() {
    [[ "$(uname)" != "Darwin" ]] && msg_error "Macarchy only works on macOS"
    msg_step "Running on macOS"
}

check_macos_version() {
    local version=$(sw_vers -productVersion)
    local major=$(echo "$version" | cut -d. -f1)
    
    if [[ "$major" -lt 14 ]]; then
        msg_warn "macOS $version detected. Macarchy works best on 14.0+ (Sonoma)"
        read -r -p "   Continue anyway? [y/N] " response
        [[ ! "$response" =~ ^[Yy]$ ]] && exit 0
    fi
    msg_step "macOS $version"
}

check_not_root() {
    [[ $EUID -eq 0 ]] && msg_error "Do not run as root"
    msg_step "Running as normal user"
}

check_home_writable() {
    [[ ! -w "$HOME" ]] && msg_error "Cannot write to $HOME"
    msg_step "Home directory writable"
}

# ─────────────────────────────────────────────────────────────────────────────
# XCODE CLI TOOLS
# ─────────────────────────────────────────────────────────────────────────────

install_xcode_cli() {
    section "Xcode Command Line Tools"
    
    if xcode-select -p &>/dev/null; then
        msg_success "Already installed"
        return 0
    fi
    
    msg_info "Installing Xcode CLI tools..."
    xcode-select --install 2>/dev/null || true
    
    echo -n "   Waiting for installation"
    until xcode-select -p &>/dev/null; do
        echo -n "."
        sleep 5
    done
    echo ""
    msg_success "Installed"
}

# ─────────────────────────────────────────────────────────────────────────────
# HOMEBREW
# ─────────────────────────────────────────────────────────────────────────────

get_brew_prefix() {
    [[ "$(uname -m)" == "arm64" ]] && echo "/opt/homebrew" || echo "/usr/local"
}

install_homebrew() {
    section "Homebrew"
    
    local brew_prefix=$(get_brew_prefix)
    
    if command -v brew &>/dev/null; then
        msg_success "Already installed"
        return 0
    fi
    
    if [[ -x "$brew_prefix/bin/brew" ]]; then
        msg_step "Found at $brew_prefix, adding to PATH"
        eval "$($brew_prefix/bin/brew shellenv)"
        msg_success "Configured"
        return 0
    fi
    
    msg_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($brew_prefix/bin/brew shellenv)"
    msg_success "Installed"
}

# ─────────────────────────────────────────────────────────────────────────────
# MODULES
# ─────────────────────────────────────────────────────────────────────────────

install_modules() {
    section "Installing Modules"
    
    # Add taps
    brew tap nikitabobko/tap 2>/dev/null || true
    brew tap FelixKratz/formulae 2>/dev/null || true
    
    # AeroSpace
    if brew list --cask aerospace &>/dev/null; then
        msg_step "aerospace ${C_DIM}(already installed)${C_RESET}"
    else
        msg_step "Installing aerospace..."
        brew install --cask aerospace
        msg_success "aerospace installed"
    fi
    
    # SketchyBar
    if brew list sketchybar &>/dev/null; then
        msg_step "sketchybar ${C_DIM}(already installed)${C_RESET}"
    else
        msg_step "Installing sketchybar..."
        brew install sketchybar
        msg_success "sketchybar installed"
    fi
    
    # Borders
    if brew list borders &>/dev/null; then
        msg_step "borders ${C_DIM}(already installed)${C_RESET}"
    else
        msg_step "Installing borders..."
        brew install borders
        msg_success "borders installed"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# MACARCHY SETUP
# ─────────────────────────────────────────────────────────────────────────────

setup_macarchy_dir() {
    section "Setting Up Macarchy"
    
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if running from within the repo
    if [[ -f "$script_dir/VERSION" ]] && [[ -d "$script_dir/modules" ]]; then
        if [[ "$script_dir" != "$MACARCHY_DIR" ]]; then
            msg_step "Linking $script_dir → $MACARCHY_DIR"
            
            [[ -L "$MACARCHY_DIR" ]] && rm "$MACARCHY_DIR"
            [[ -d "$MACARCHY_DIR" ]] && mv "$MACARCHY_DIR" "$BACKUP_DIR/macarchy-old"
            
            ln -s "$script_dir" "$MACARCHY_DIR"
            msg_success "Linked"
        else
            msg_success "Already at $MACARCHY_DIR"
        fi
    else
        # Clone from repo
        if [[ -d "$MACARCHY_DIR/.git" ]]; then
            msg_step "Updating existing installation..."
            cd "$MACARCHY_DIR" && git pull origin main
            msg_success "Updated"
        else
            [[ -d "$MACARCHY_DIR" ]] && mv "$MACARCHY_DIR" "$BACKUP_DIR/macarchy-old"
            msg_step "Cloning from repository..."
            git clone "$MACARCHY_REPO" "$MACARCHY_DIR"
            msg_success "Cloned"
        fi
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# BACKUP
# ─────────────────────────────────────────────────────────────────────────────

backup_existing() {
    section "Checking Existing Configs"
    
    local backed_up=false
    
    # Aerospace
    if [[ -e "$HOME/.aerospace.toml" ]] && [[ ! -L "$HOME/.aerospace.toml" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp "$HOME/.aerospace.toml" "$BACKUP_DIR/"
        msg_step "Backed up ~/.aerospace.toml"
        backed_up=true
    elif [[ -L "$HOME/.aerospace.toml" ]] && [[ "$(readlink "$HOME/.aerospace.toml")" == *"macarchy"* ]]; then
        msg_step "aerospace.toml ${C_DIM}(already managed)${C_RESET}"
    fi
    
    # SketchyBar
    if [[ -e "$HOME/.config/sketchybar" ]] && [[ ! -L "$HOME/.config/sketchybar" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -R "$HOME/.config/sketchybar" "$BACKUP_DIR/"
        msg_step "Backed up ~/.config/sketchybar"
        backed_up=true
    elif [[ -L "$HOME/.config/sketchybar" ]] && [[ "$(readlink "$HOME/.config/sketchybar")" == *"macarchy"* ]]; then
        msg_step "sketchybar ${C_DIM}(already managed)${C_RESET}"
    fi
    
    if [[ "$backed_up" == true ]]; then
        msg_success "Backups saved to $BACKUP_DIR"
    else
        msg_success "No backups needed"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# SYMLINKS
# ─────────────────────────────────────────────────────────────────────────────

create_symlinks() {
    section "Creating Symlinks"
    
    # Get the actual directory (resolve ~/.macarchy symlink if needed)
    local actual_dir
    if [[ -L "$MACARCHY_DIR" ]]; then
        actual_dir=$(readlink "$MACARCHY_DIR")
    else
        actual_dir="$MACARCHY_DIR"
    fi
    
    # Use absolute path to avoid chained symlink issues
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$script_dir/VERSION" ]]; then
        actual_dir="$script_dir"
    fi
    
    # Aerospace - use direct path (AeroSpace doesn't follow chained symlinks)
    [[ -e "$HOME/.aerospace.toml" ]] || [[ -L "$HOME/.aerospace.toml" ]] && rm -f "$HOME/.aerospace.toml"
    ln -s "$actual_dir/modules/aerospace/aerospace.toml" "$HOME/.aerospace.toml"
    msg_step "~/.aerospace.toml → $actual_dir/modules/aerospace/aerospace.toml"
    
    # SketchyBar - use direct path
    mkdir -p "$HOME/.config"
    [[ -e "$HOME/.config/sketchybar" ]] || [[ -L "$HOME/.config/sketchybar" ]] && rm -rf "$HOME/.config/sketchybar"
    ln -s "$actual_dir/modules/sketchybar" "$HOME/.config/sketchybar"
    msg_step "~/.config/sketchybar → $actual_dir/modules/sketchybar"
    
    msg_success "Symlinks created"
}

# ─────────────────────────────────────────────────────────────────────────────
# CONFIG INITIALIZATION
# ─────────────────────────────────────────────────────────────────────────────

setup_config() {
    section "Initializing Configuration"
    
    local config_dir="$MACARCHY_DIR/config"
    local defaults_dir="$MACARCHY_DIR/defaults"
    local themes_dir="$MACARCHY_DIR/themes"
    
    # Ensure config directory exists
    mkdir -p "$config_dir"
    
    # Initialize settings from defaults if not present or empty
    if [[ ! -s "$config_dir/settings.sh" ]]; then
        if [[ -f "$defaults_dir/settings.sh" ]]; then
            cp "$defaults_dir/settings.sh" "$config_dir/settings.sh"
            msg_step "Initialized settings.sh from defaults"
        else
            msg_warn "Default settings not found"
        fi
    else
        msg_step "settings.sh ${C_DIM}(already exists)${C_RESET}"
    fi
    
    # Initialize theme from default if not present or empty
    if [[ ! -s "$config_dir/theme.sh" ]]; then
        # Get default theme name
        local default_theme="orange"
        if [[ -f "$defaults_dir/DEFAULT_THEME" ]]; then
            default_theme=$(cat "$defaults_dir/DEFAULT_THEME" | tr -d '[:space:]')
        fi
        
        if [[ -f "$themes_dir/${default_theme}.sh" ]]; then
            cp "$themes_dir/${default_theme}.sh" "$config_dir/theme.sh"
            msg_step "Initialized theme.sh with $default_theme"
        else
            msg_warn "Default theme not found: $default_theme"
        fi
    else
        msg_step "theme.sh ${C_DIM}(already exists)${C_RESET}"
    fi
    
    msg_success "Configuration initialized"
}

# ─────────────────────────────────────────────────────────────────────────────
# PATH & CLI
# ─────────────────────────────────────────────────────────────────────────────

setup_path() {
    section "Setting Up CLI"
    
    local shell_rc=""
    [[ "$SHELL" == *"zsh"* ]] && shell_rc="$HOME/.zshrc"
    [[ "$SHELL" == *"bash"* ]] && shell_rc="$HOME/.bashrc"
    [[ -z "$shell_rc" ]] && shell_rc="$HOME/.profile"
    
    local path_line='export PATH="$HOME/.macarchy/bin:$PATH"'
    
    if grep -q "macarchy/bin" "$shell_rc" 2>/dev/null; then
        msg_step "PATH already configured"
    else
        echo "" >> "$shell_rc"
        echo "# Macarchy" >> "$shell_rc"
        echo "$path_line" >> "$shell_rc"
        msg_step "Added to $shell_rc"
    fi
    
    export PATH="$HOME/.macarchy/bin:$PATH"
    
    # Make scripts executable
    chmod +x "$MACARCHY_DIR/bin/macarchy"
    chmod +x "$MACARCHY_DIR/modules/"*/module.sh 2>/dev/null || true
    chmod +x "$MACARCHY_DIR/modules/sketchybar/plugins/"*.sh 2>/dev/null || true
    chmod +x "$MACARCHY_DIR/modules/sketchybar/items/"*.sh 2>/dev/null || true
    chmod +x "$MACARCHY_DIR/modules/sketchybar/sketchybarrc" 2>/dev/null || true
    chmod +x "$MACARCHY_DIR/modules/sketchybar/sketchybar_wrapper.sh" 2>/dev/null || true
    
    msg_success "CLI configured"
}

# ─────────────────────────────────────────────────────────────────────────────
# LOGIN ITEMS
# ─────────────────────────────────────────────────────────────────────────────

setup_login_items() {
    section "Startup Configuration"
    
    if osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null | grep -q "AeroSpace"; then
        msg_success "AeroSpace already in login items"
        return 0
    fi
    
    read -r -p "   Start Macarchy at login? [Y/n] " response
    response=${response:-Y}
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/AeroSpace.app", hidden:false}' 2>/dev/null
        msg_success "Added to login items"
    else
        msg_step "Skipped (run: macarchy login enable)"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# SYSTEM PREFERENCES
# ─────────────────────────────────────────────────────────────────────────────

setup_system_prefs() {
    section "System Preferences"
    
    echo -e "  ${C_DIM}Macarchy works best with auto-hidden dock and menu bar.${C_RESET}"
    echo ""
    
    read -r -p "   Auto-hide Dock and Menu Bar? [Y/n] " response
    response=${response:-Y}
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Auto-hide Dock
        msg_step "Enabling Dock auto-hide..."
        defaults write com.apple.dock autohide -bool true
        defaults write com.apple.dock autohide-delay -float 0
        defaults write com.apple.dock autohide-time-modifier -float 0.3
        
        # Auto-hide Menu Bar (macOS Ventura 13+)
        msg_step "Enabling Menu Bar auto-hide..."
        # _HIHideMenuBar: true = always hide when not in use
        defaults write NSGlobalDomain _HIHideMenuBar -bool true
        
        # Restart Dock to apply changes
        killall Dock 2>/dev/null || true
        
        # Update settings file to reflect the choice
        if [[ -f "$MACARCHY_DIR/config/settings.sh" ]]; then
            sed -i '' 's/AUTOHIDE_DOCK="false"/AUTOHIDE_DOCK="true"/' "$MACARCHY_DIR/config/settings.sh" 2>/dev/null || true
            sed -i '' 's/AUTOHIDE_MENUBAR="false"/AUTOHIDE_MENUBAR="true"/' "$MACARCHY_DIR/config/settings.sh" 2>/dev/null || true
        fi
        
        msg_success "System preferences configured"
        echo ""
        echo -e "  ${C_DIM}Note: Menu bar changes may require logout to take effect${C_RESET}"
    else
        # Update settings file
        if [[ -f "$MACARCHY_DIR/config/settings.sh" ]]; then
            sed -i '' 's/AUTOHIDE_DOCK="true"/AUTOHIDE_DOCK="false"/' "$MACARCHY_DIR/config/settings.sh" 2>/dev/null || true
            sed -i '' 's/AUTOHIDE_MENUBAR="true"/AUTOHIDE_MENUBAR="false"/' "$MACARCHY_DIR/config/settings.sh" 2>/dev/null || true
        fi
        msg_step "Skipped (run: macarchy system dock on / macarchy system menubar on)"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# START SERVICES
# ─────────────────────────────────────────────────────────────────────────────

apply_config() {
    section "Applying Configuration"
    
    # Run macarchy apply to generate all config files (colors.sh, etc.)
    if [[ -x "$MACARCHY_DIR/bin/macarchy" ]]; then
        "$MACARCHY_DIR/bin/macarchy" apply >/dev/null 2>&1 || {
            # Fallback: manually generate colors.sh if apply fails
            if [[ -f "$MACARCHY_DIR/config/theme.sh" ]]; then
                source "$MACARCHY_DIR/config/theme.sh"
                source "$MACARCHY_DIR/config/settings.sh" 2>/dev/null || true
                cat > "$MACARCHY_DIR/modules/sketchybar/colors.sh" << EOF
#!/bin/bash
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
export ACCENT=$ACCENT
export ACCENT_DIM=$ACCENT_DIM
export BAR_COLOR=$BAR_COLOR
export ICON_COLOR=$ICON_COLOR
export LABEL_COLOR=$LABEL_COLOR
export BACKGROUND_1=$BACKGROUND_1
export BACKGROUND_2=$BACKGROUND_2
export POPUP_BACKGROUND_COLOR=$POPUP_BACKGROUND_COLOR
export POPUP_BORDER_COLOR=$POPUP_BORDER_COLOR
export SHADOW_COLOR=$SHADOW_COLOR
EOF
            fi
        }
        msg_success "Configuration applied"
    else
        msg_warn "Could not apply configuration"
    fi
}

start_services() {
    section "Starting Services"
    
    # Stop existing
    killall AeroSpace 2>/dev/null || true
    killall sketchybar 2>/dev/null || true
    killall borders 2>/dev/null || true
    sleep 1
    
    # Start AeroSpace (it starts sketchybar + borders)
    open -a AeroSpace
    sleep 3
    
    # Verify
    local all_good=true
    
    if pgrep -x "AeroSpace" >/dev/null; then
        msg_step "AeroSpace ${C_GREEN}●${C_RESET}"
    else
        msg_step "AeroSpace ${C_RED}○${C_RESET}"
        all_good=false
    fi
    
    if pgrep -x "sketchybar" >/dev/null; then
        msg_step "SketchyBar ${C_GREEN}●${C_RESET}"
    else
        msg_step "SketchyBar ${C_RED}○${C_RESET}"
        all_good=false
    fi
    
    if pgrep -x "borders" >/dev/null; then
        msg_step "Borders ${C_GREEN}●${C_RESET}"
    else
        msg_step "Borders ${C_RED}○${C_RESET}"
        all_good=false
    fi
    
    [[ "$all_good" == true ]] && msg_success "All services running" || msg_warn "Some services failed"
}

# ─────────────────────────────────────────────────────────────────────────────
# SUCCESS
# ─────────────────────────────────────────────────────────────────────────────

print_success() {
    echo ""
    echo -e "${C_GREEN}╔═══════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_GREEN}║${C_RESET}        ${C_BOLD}🎉 MACARCHY INSTALLED SUCCESSFULLY! 🎉${C_RESET}              ${C_GREEN}║${C_RESET}"
    echo -e "${C_GREEN}╚═══════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
    echo -e "${C_BOLD}Quick Start${C_RESET}"
    echo "  Opt + 1-9            Switch workspace"
    echo "  Opt + ←↓↑→           Navigate windows"
    echo "  Opt + Shift + ...    Move windows"
    echo "  Opt + Enter          Open terminal"
    echo ""
    echo -e "${C_BOLD}Commands${C_RESET}"
    echo "  macarchy help        Show all commands"
    echo "  macarchy theme       Switch color themes"
    echo "  macarchy apply       Apply config changes"
    echo "  macarchy status      Check module status"
    echo ""
    echo -e "${C_DIM}Config: ~/.macarchy/config/${C_RESET}"
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${C_DIM}Backup: $BACKUP_DIR${C_RESET}"
    fi
    
    echo ""
    msg_info "Open a new terminal to use the 'macarchy' command"
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN
# ─────────────────────────────────────────────────────────────────────────────

main() {
    print_banner
    
    section "Preflight Checks"
    check_macos
    check_macos_version
    check_not_root
    check_home_writable
    msg_success "All checks passed"
    
    install_xcode_cli
    install_homebrew
    install_modules
    setup_macarchy_dir
    backup_existing
    create_symlinks
    setup_config
    setup_path
    apply_config
    setup_login_items
    setup_system_prefs
    start_services
    print_success
}

main "$@"
