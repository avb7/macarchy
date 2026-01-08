# Macarchy

```
    __  ___                           __
   /  |/  /___ __________ ___________/ /_  __  __
  / /|_/ / __ `/ ___/ __ `/ ___/ ___/ __ \/ / / /
 / /  / / /_/ / /__/ /_/ / /  / /__/ / / / /_/ /
/_/  /_/\__,_/\___/\__,_/_/   \___/_/ /_/\__, /
                                        /____/
```

**A modular tiling desktop environment for macOS.**
<p align="center">
  <img src="https://github.com/user-attachments/assets/ced65090-badd-4801-b91b-f97a1080a4e1" width="45%" />
  <img src="https://github.com/user-attachments/assets/fcf42893-3800-4ebc-8b22-1fc83c9de65f" width="45%" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/702c792f-68cc-4ce7-b1fc-770002fb926d" width="45%" />
  <img src="https://github.com/user-attachments/assets/47a124f5-0c2b-4cd6-b117-248acd139466" width="45%" />
</p>


Macarchy combines [AeroSpace](https://github.com/nikitabobko/AeroSpace), [SketchyBar](https://github.com/FelixKratz/SketchyBar), and [JankyBorders](https://github.com/FelixKratz/JankyBorders) into a cohesive, portable, and easily customizable desktop experience.

## Features

- 🧩 **Modular Architecture** — Each component is a self-contained module
- 🎨 **Centralized Theming** — One config controls colors across all modules
- ⚡ **Instant Theme Switching** — `macarchy theme nord` applies immediately
- 🪟 **Tiling Window Management** — Automatic window tiling with AeroSpace
- 📊 **Custom Menu Bar** — Beautiful, informative bar with SketchyBar
- 🖼️ **Window Borders** — Visual focus indicator with colored borders
- ⌨️ **Keyboard Navigation** — Opt + Arrow keys to navigate

## Quick Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/avb7/macarchy/main/install.sh)"
```

Or clone manually:

```bash
git clone https://github.com/avb7/macarchy.git ~/.macarchy
cd ~/.macarchy && ./install.sh
```

## Architecture

```
~/.macarchy/
├── config/
│   ├── theme.sh          # 🎨 Colors (single source of truth)
│   └── settings.sh       # ⚙️ Gaps, fonts, behavior
│
├── modules/              # 🧩 Self-contained modules
│   ├── aerospace/        # Tiling window manager
│   │   ├── aerospace.toml
│   │   └── module.sh
│   ├── sketchybar/       # Custom menu bar
│   │   ├── sketchybarrc
│   │   ├── items/
│   │   ├── plugins/
│   │   └── module.sh
│   └── borders/          # Window borders
│       └── module.sh
│
├── themes/               # Pre-built themes (11+)
│   ├── orange.sh
│   ├── azure.sh
│   ├── catppuccin-mocha.sh
│   ├── nord.sh
│   ├── tokyo-night.sh
│   ├── dracula.sh
│   ├── gruvbox-dark.sh
│   ├── rose-pine.sh
│   ├── kanagawa.sh
│   ├── everforest.sh
│   └── cyberpunk.sh
│
└── bin/
    └── macarchy          # CLI tool
```

## CLI Commands

```bash
# Service management
macarchy start              # Start all modules
macarchy stop               # Stop all modules
macarchy restart            # Restart all modules
macarchy status             # Show module status

# Configuration
macarchy apply              # Apply config changes to all modules
macarchy theme              # List available themes
macarchy theme nord         # Switch theme (applies immediately)
macarchy config             # Show current configuration
macarchy config edit        # Edit settings in $EDITOR
macarchy edit theme         # Edit theme file

# Maintenance
macarchy doctor             # Run diagnostics
macarchy update             # Update Macarchy & dependencies

# Help
macarchy help               # Show all commands
```

## Themes

Switch themes instantly — colors update across all modules and the CLI itself:

```bash
macarchy theme list         # See available themes
macarchy theme <name>       # Apply theme
```

### Available Themes

| Theme | Accent | Vibe |
|-------|--------|------|
| `orange` | 🟠 Orange | Default, warm & bold |
| `amber` | 🟠 Amber | Warm industrial cyberpunk |
| `azure` | 🔵 Azure | Cosmic space blues |
| `catppuccin-mocha` | 🟣 Lavender | Soothing pastel |
| `dracula` | 🔮 Purple | Classic dark |
| `tokyo-night` | 🔵 Blue | Neon city nights |
| `nord` | 🧊 Frost | Arctic & clean |
| `gruvbox-dark` | 🟠 Orange | Retro, earthy warmth |
| `rose-pine` | 🌸 Rose | Elegant & soft |
| `kanagawa` | 🌊 Wave Blue | Japanese aesthetic |
| `everforest` | 🌲 Green | Forest calm |
| `cyberpunk` | 💗 Neon Pink | High-contrast neon |

Changes apply immediately to all modules. Wallpapers can auto-switch with themes.

## Key Bindings

| Binding | Action |
|---------|--------|
| `Opt + 1-9` | Switch workspace |
| `Opt + ←↓↑→` | Focus window left/down/up/right |
| `Opt + Shift + ←↓↑→` | Move window |
| `Opt + Enter` | Open terminal |
| `Opt + Space` | Open Raycast |
| `Opt + F` | Toggle fullscreen |
| `Opt + T` | Toggle floating |
| `Opt + Tab` | Next workspace |

See [docs/KEYBINDINGS.md](docs/KEYBINDINGS.md) for the full list.

## Customization

### Changing Colors

Edit `~/.macarchy/config/theme.sh`:

```bash
export ACCENT="0xffFF8C00"        # Focused window (orange)
export ACCENT_DIM="0xff2D1B00"    # Unfocused windows
export BAR_COLOR="0xff0a0a0a"     # Bar background
```

Then apply:

```bash
macarchy apply
```

### Changing Settings

Edit `~/.macarchy/config/settings.sh`:

```bash
export GAP_INNER_H="10"           # Gap between windows
export GAP_OUTER_TOP="60"         # Gap from top (for bar)
export BORDER_WIDTH="5.0"         # Border thickness
export BAR_HEIGHT="40"            # Bar height
```

### Creating a Custom Theme

```bash
cp ~/.macarchy/themes/orange.sh ~/.macarchy/themes/my-theme.sh
# Edit my-theme.sh
macarchy theme my-theme
```

## Module System

Each module in `modules/` has a `module.sh` that implements:

```bash
module_is_installed()    # Check if dependency is installed
module_is_running()      # Check if process is running
module_install()         # Install the dependency
module_start()           # Start the service
module_stop()            # Stop the service
module_reload()          # Reload configuration
module_apply_theme()     # Apply theme changes
module_link()            # Create symlinks
module_unlink()          # Remove symlinks
```

To add a new module, create a directory under `modules/` with a `module.sh` implementing these functions.

## Requirements

- macOS 14.0+ (Sonoma)
- [Homebrew](https://brew.sh)

## Uninstall

```bash
./uninstall.sh
```

This will:
- Stop all services
- Remove symlinks
- Optionally restore your original configs
- Optionally remove dependencies

## Credits

Built on:
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) by Nikita Bobko
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) by Felix Kratz
- [JankyBorders](https://github.com/FelixKratz/JankyBorders) by Felix Kratz

Inspired by [webpro/dotfiles](https://github.com/webpro/dotfiles).

> **Disclaimer**  
> This is an experimental build tested only on macOS 15.6.1.  
> The software is provided "as is", without any warranties, and the author is not liable for any damages, data loss, or other issues arising from its use.


## License

MIT
