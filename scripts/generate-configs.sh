#!/bin/bash
# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     MACARCHY CONFIG GENERATOR                             ║
# ║                                                                           ║
# ║  Generates module configs from centralized theme and settings.            ║
# ║  Called by: macarchy apply                                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACARCHY_DIR="${MACARCHY_DIR:-$(dirname "$SCRIPT_DIR")}"

# Source configs
source "$MACARCHY_DIR/config/theme.sh"
source "$MACARCHY_DIR/config/settings.sh"

echo "Generating configs from theme..."

# Apply to each module
for module_dir in "$MACARCHY_DIR/modules"/*/; do
    module_file="$module_dir/module.sh"
    if [[ -f "$module_file" ]]; then
        source "$module_file"
        if declare -f module_apply_theme &>/dev/null; then
            module_apply_theme
            echo "  ✓ $(basename "$module_dir")"
        fi
    fi
done

echo "Done!"
