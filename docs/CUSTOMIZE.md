# Customization Guide

This guide explains how to customize every aspect of Macarchy.

## Table of Contents

- [Theme System](#theme-system)
- [Changing Colors](#changing-colors)
- [Key Bindings](#key-bindings)
- [Bar Items](#bar-items)
- [Window Borders](#window-borders)
- [Gaps and Spacing](#gaps-and-spacing)
- [Creating Custom Themes](#creating-custom-themes)

---

## Theme System

Macarchy uses a single source of truth for colors: `~/.macarchy/config/theme.sh`

When you edit this file and run `macarchy reload`, colors propagate to:
- SketchyBar (menu bar)
- Borders (window highlighting)
- AeroSpace (indirectly, via borders command)

### Applying a Pre-built Theme

```bash
macarchy theme list              # See available themes
macarchy theme catppuccin-mocha  # Apply a theme
```

Available themes:
- `orange` — Default orange accent
- `catppuccin-mocha` — Purple/mauve accent
- `nord` — Cyan/frost accent
- `tokyo-night` — Blue accent
- `dracula` — Purple accent

---

## Changing Colors

Edit `~/.macarchy/config/theme.sh`:

```bash
# Color format: 0xAARRGGBB
# AA = Alpha (ff = fully opaque, 00 = transparent)
# RR = Red, GG = Green, BB = Blue

# Window border colors
export ACCENT="0xffFF8C00"        # Focused window (orange)
export ACCENT_DIM="0xff2D1B00"    # Unfocused windows (dark)

# Bar background
export BAR_COLOR="0xff0a0a0a"     # Near-black

# Item backgrounds
export BACKGROUND_1="0xff1a1a1a"  # Slightly lighter
export BACKGROUND_2="0xff2a2a2a"  # Item borders
```

After editing:

```bash
macarchy reload
```

---

## Key Bindings

Edit `~/.macarchy/aerospace/aerospace.toml`

### Changing the Modifier Key

Default modifier is `alt`. To use `cmd` instead:

```toml
# Change all alt-* bindings to cmd-*
cmd-h = 'focus left'
cmd-j = 'focus down'
cmd-k = 'focus up'
cmd-l = 'focus right'
```

### Adding Custom Bindings

```toml
[mode.main.binding]
    # Launch specific apps
    alt-shift-c = 'exec-and-forget open -a "Visual Studio Code"'
    alt-shift-f = 'exec-and-forget open -a "Finder"'
    alt-shift-s = 'exec-and-forget open -a "Slack"'
    
    # Custom layouts
    alt-shift-e = 'layout tiles horizontal'
    alt-shift-r = 'layout tiles vertical'
```

After editing:

```bash
macarchy reload
```

---

## Bar Items

Bar items are configured in `~/.macarchy/sketchybar/items/`

### Disabling an Item

Edit `~/.macarchy/sketchybar/sketchybarrc` and comment out the source line:

```bash
# source "$ITEM_DIR/spotify.sh"    # Commented out = disabled
source "$ITEM_DIR/datetime.sh"
```

### Modifying an Item

Each item file (e.g., `items/battery.sh`) defines:
- Icon
- Font
- Colors
- Update frequency
- Position (left, center, right)

Example — change battery update frequency:

```bash
# In items/battery.sh
battery=(
  script="$PLUGIN_DIR/battery.sh"
  update_freq=60          # Update every 60 seconds instead of 120
  ...
)
```

### Item Positions

```bash
sketchybar --add item myitem left     # Left side of bar
sketchybar --add item myitem center   # Center of bar
sketchybar --add item myitem right    # Right side of bar
```

---

## Window Borders

Edit `~/.macarchy/borders/config.sh`:

```bash
export BORDER_WIDTH="5.0"        # Border thickness (pixels)
export BORDER_STYLE="round"      # round, square, or uniform

# Exclude apps from getting borders
export BORDER_BLACKLIST="Finder,Preview"
```

The border colors come from `config/theme.sh`:
- `ACCENT` — Focused window color
- `ACCENT_DIM` — Unfocused window color

---

## Gaps and Spacing

### Window Gaps (AeroSpace)

Edit `~/.macarchy/aerospace/aerospace.toml`:

```toml
[gaps]
    inner.horizontal = 10    # Gap between windows horizontally
    inner.vertical = 10      # Gap between windows vertically
    outer.left = 15          # Gap from left screen edge
    outer.right = 15         # Gap from right screen edge
    outer.bottom = 15        # Gap from bottom
    outer.top = 60           # Gap from top (space for bar)
```

### Bar Dimensions

Edit `~/.macarchy/config/theme.sh`:

```bash
export BAR_HEIGHT="40"       # Bar height in pixels
export BAR_MARGIN="10"       # Margin from screen edges
export BAR_Y_OFFSET="10"     # Vertical offset from top
```

Note: If you change `BAR_HEIGHT`, also adjust `GAP_TOP` in aerospace to match.

---

## Creating Custom Themes

1. Copy an existing theme:

```bash
cp ~/.macarchy/themes/orange.sh ~/.macarchy/themes/my-theme.sh
```

2. Edit `my-theme.sh` with your colors

3. Apply it:

```bash
macarchy theme my-theme
```

### Theme File Structure

```bash
#!/bin/bash
# Theme: My Custom Theme

# Base colors
export BLACK="0xff000000"
export WHITE="0xffffffff"

# Accent (window borders)
export ACCENT="0xff00ff00"      # Green focused
export ACCENT_DIM="0xff003300"  # Dark green unfocused

# Bar
export BAR_COLOR="0xff111111"
export BACKGROUND_1="0xff222222"
export BACKGROUND_2="0xff333333"
export ICON_COLOR="$WHITE"
export LABEL_COLOR="$WHITE"

# ... rest of theme variables
```

---

## Advanced: Mode Toggle

The bar has a Desktop/Laptop mode toggle (the `D` or `L` button).

- **Desktop Mode**: Solid bar background, item backgrounds visible, larger top gap
- **Laptop Mode**: Transparent bar, no item backgrounds, minimal gaps

This is handled by `~/.macarchy/sketchybar/plugins/mode_toggle_click.sh`

You can customize the behavior by editing that file.


