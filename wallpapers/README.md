# Theme Wallpapers

Place wallpapers here with names matching the theme files.

## Naming Convention

```
<theme-name>.jpg   (or .png, .heic)
```

## Examples

```
orange.jpg             → Used by orange theme
catppuccin-mocha.png   → Used by catppuccin-mocha theme  
nord.jpg               → Used by nord theme
tokyo-night.jpg        → Used by tokyo-night theme
dracula.png            → Used by dracula theme
```

## Supported Formats

- `.jpg` / `.jpeg`
- `.png`
- `.heic`

## Adding Custom Wallpapers

1. Add your wallpaper image to this directory
2. Name it to match your theme (e.g., `my-theme.jpg`)
3. The wallpaper will automatically apply when you run `macarchy theme my-theme`

## Disable Auto-Wallpaper

To keep your current wallpaper when switching themes, edit `~/.macarchy/config/settings.sh`:

```bash
export AUTO_WALLPAPER="false"
```

