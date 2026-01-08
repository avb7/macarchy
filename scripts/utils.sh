#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        MACARCHY UTILITY FUNCTIONS                         ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ─────────────────────────────────────────────────────────────────────────────
# COLORS FOR OUTPUT
# ─────────────────────────────────────────────────────────────────────────────

export COLOR_RED='\033[0;31m'
export COLOR_GREEN='\033[0;32m'
export COLOR_YELLOW='\033[0;33m'
export COLOR_BLUE='\033[0;34m'
export COLOR_MAGENTA='\033[0;35m'
export COLOR_CYAN='\033[0;36m'
export COLOR_BOLD='\033[1m'
export COLOR_NC='\033[0m'  # No Color

# ─────────────────────────────────────────────────────────────────────────────
# LOGGING FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────

info() {
    echo -e "${COLOR_BLUE}[INFO]${COLOR_NC} $1"
}

success() {
    echo -e "${COLOR_GREEN}[OK]${COLOR_NC} $1"
}

warn() {
    echo -e "${COLOR_YELLOW}[WARN]${COLOR_NC} $1"
}

error() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_NC} $1"
    exit 1
}

error_noexit() {
    echo -e "${COLOR_RED}[ERROR]${COLOR_NC} $1"
}

# ─────────────────────────────────────────────────────────────────────────────
# SYSTEM DETECTION
# ─────────────────────────────────────────────────────────────────────────────

# Detect CPU architecture
get_arch() {
    uname -m
}

# Detect macOS version (e.g., "14.0" for Sonoma)
get_macos_version() {
    sw_vers -productVersion
}

# Check if macOS version is at least the given version
macos_version_gte() {
    local required="$1"
    local current
    current=$(get_macos_version)
    
    # Compare versions using sort -V
    printf '%s\n%s\n' "$required" "$current" | sort -V | head -n1 | grep -q "^${required}$"
}

# Get Homebrew prefix based on architecture
get_brew_prefix() {
    if [[ "$(get_arch)" == "arm64" ]]; then
        echo "/opt/homebrew"
    else
        echo "/usr/local"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# DEPENDENCY CHECKS
# ─────────────────────────────────────────────────────────────────────────────

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if Homebrew is installed
brew_installed() {
    command_exists brew
}

# Check if a brew package is installed
brew_package_installed() {
    local package="$1"
    brew list "$package" &>/dev/null
}

# Check if a brew cask is installed
brew_cask_installed() {
    local cask="$1"
    brew list --cask "$cask" &>/dev/null
}

# Check if Xcode CLI tools are installed
xcode_cli_installed() {
    xcode-select -p &>/dev/null
}

# ─────────────────────────────────────────────────────────────────────────────
# PROCESS MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────

# Check if a process is running
is_running() {
    pgrep -x "$1" >/dev/null 2>&1
}

# Kill a process gracefully
kill_process() {
    local process="$1"
    if is_running "$process"; then
        killall "$process" 2>/dev/null
        return 0
    fi
    return 1
}

# Wait for a process to start (with timeout)
wait_for_process() {
    local process="$1"
    local timeout="${2:-10}"
    local count=0
    
    while ! is_running "$process"; do
        sleep 1
        ((count++))
        if [[ $count -ge $timeout ]]; then
            return 1
        fi
    done
    return 0
}

# ─────────────────────────────────────────────────────────────────────────────
# FILE OPERATIONS
# ─────────────────────────────────────────────────────────────────────────────

# Check if a path is a symlink pointing to macarchy
is_macarchy_symlink() {
    local path="$1"
    [[ -L "$path" ]] && [[ "$(readlink "$path")" == *"macarchy"* ]]
}

# Create a symlink, removing existing file/symlink first
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # Remove existing (file, dir, or broken symlink)
    if [[ -e "$dest" ]] || [[ -L "$dest" ]]; then
        rm -rf "$dest"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Create symlink
    ln -s "$src" "$dest"
}

# Backup a file/directory with timestamp
backup_path() {
    local src="$1"
    local backup_dir="$2"
    local name
    name=$(basename "$src")
    
    if [[ -e "$src" ]] && ! is_macarchy_symlink "$src"; then
        mkdir -p "$backup_dir"
        cp -R "$src" "$backup_dir/$name"
        return 0
    fi
    return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# USER INTERACTION
# ─────────────────────────────────────────────────────────────────────────────

# Ask yes/no question, return 0 for yes, 1 for no
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"  # Default to no
    local response
    
    if [[ "$default" =~ ^[Yy]$ ]]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi
    
    read -r -p "$prompt" response
    response=${response:-$default}
    
    [[ "$response" =~ ^[Yy]$ ]]
}

# Ask for choice from options
ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local i=1
    
    echo "$prompt"
    for opt in "${options[@]}"; do
        echo "  [$i] $opt"
        ((i++))
    done
    
    read -r -p "Choice: " choice
    echo "$choice"
}

# ─────────────────────────────────────────────────────────────────────────────
# LOGIN ITEMS (macOS)
# ─────────────────────────────────────────────────────────────────────────────

# Check if an app is in login items
is_login_item() {
    local app_name="$1"
    osascript -e "tell application \"System Events\" to get the name of every login item" 2>/dev/null | grep -q "$app_name"
}

# Add app to login items
add_login_item() {
    local app_path="$1"
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app_path\", hidden:false}" 2>/dev/null
}

# Remove app from login items
remove_login_item() {
    local app_name="$1"
    osascript -e "tell application \"System Events\" to delete login item \"$app_name\"" 2>/dev/null
}


