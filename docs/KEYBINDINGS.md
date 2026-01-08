# Key Bindings Reference

All key bindings use `Opt` (Option/Alt) as the modifier key by default.

## Window Navigation

| Binding | Action |
|---------|--------|
| `Opt + ←` | Focus window to the left |
| `Opt + ↓` | Focus window below |
| `Opt + ↑` | Focus window above |
| `Opt + →` | Focus window to the right |

## Window Movement

| Binding | Action |
|---------|--------|
| `Opt + Shift + ←` | Move window left |
| `Opt + Shift + ↓` | Move window down |
| `Opt + Shift + ↑` | Move window up |
| `Opt + Shift + →` | Move window right |

## Window Resizing

| Binding | Action |
|---------|--------|
| `Opt + =` | Increase window size |
| `Opt + -` | Decrease window size |

## Window Actions

| Binding | Action |
|---------|--------|
| `Opt + F` | Toggle fullscreen |
| `Opt + T` | Toggle floating/tiling |
| `Opt + W` | Close window |

## Workspaces

| Binding | Action |
|---------|--------|
| `Opt + 1` | Switch to workspace 1 |
| `Opt + 2` | Switch to workspace 2 |
| `Opt + 3` | Switch to workspace 3 |
| `Opt + 4` | Switch to workspace 4 |
| `Opt + 5` | Switch to workspace 5 |
| `Opt + 6` | Switch to workspace 6 |
| `Opt + 7` | Switch to workspace 7 |
| `Opt + 8` | Switch to workspace 8 |
| `Opt + 9` | Switch to workspace 9 |
| `Opt + Tab` | Next workspace |
| `Opt + Shift + Tab` | Previous workspace |
| `Opt + Ctrl + Tab` | Back and forth (last workspace) |

## Move Window to Workspace

| Binding | Action |
|---------|--------|
| `Opt + Shift + 1` | Move window to workspace 1 |
| `Opt + Shift + 2` | Move window to workspace 2 |
| `Opt + Shift + 3` | Move window to workspace 3 |
| `Opt + Shift + 4` | Move window to workspace 4 |
| `Opt + Shift + 5` | Move window to workspace 5 |
| `Opt + Shift + 6` | Move window to workspace 6 |
| `Opt + Shift + 7` | Move window to workspace 7 |
| `Opt + Shift + 8` | Move window to workspace 8 |
| `Opt + Shift + 9` | Move window to workspace 9 |

## Multi-Monitor

| Binding | Action |
|---------|--------|
| `Opt + Ctrl + ←` | Focus monitor to the left |
| `Opt + Ctrl + →` | Focus monitor to the right |
| `Opt + Ctrl + ↑` | Focus monitor above |
| `Opt + Ctrl + ↓` | Focus monitor below |
| `Opt + Ctrl + Shift + ←` | Move window to monitor left |
| `Opt + Ctrl + Shift + →` | Move window to monitor right |
| `Opt + Ctrl + Shift + ↑` | Move window to monitor above |
| `Opt + Ctrl + Shift + ↓` | Move window to monitor below |
| `Opt + Shift + Ctrl + Tab` | Move workspace to next monitor |

## Layout

| Binding | Action |
|---------|--------|
| `Opt + /` | Toggle horizontal/vertical tiles |
| `Opt + ,` | Toggle accordion mode |

## Application Launchers

| Binding | Action |
|---------|--------|
| `Opt + Enter` | Open Terminal |
| `Opt + Space` | Open Raycast |
| `Opt + Shift + B` | Open Arc Browser |

## Service Mode

| Binding | Action |
|---------|--------|
| `Opt + Shift + ;` | Enter service mode |

### In Service Mode

| Binding | Action |
|---------|--------|
| `Esc` | Reload config and exit |
| `R` | Reset (flatten) workspace layout |
| `F` | Toggle float/tile |
| `Backspace` | Close all windows except current |
| `Opt + Shift + ←↓↑→` | Join window with neighbor |
| `↑` | Volume up |
| `↓` | Volume down |
| `Shift + ↓` | Mute |

---

## Customizing Key Bindings

Edit `~/.macarchy/modules/aerospace/aerospace.toml` and reload:

```bash
macarchy apply
```

### Example: Use Cmd instead of Opt

```toml
[mode.main.binding]
    cmd-left = 'focus left'
    cmd-down = 'focus down'
    cmd-up = 'focus up'
    cmd-right = 'focus right'
```

### Example: Add app launchers

```toml
[mode.main.binding]
    alt-shift-c = 'exec-and-forget open -a "Visual Studio Code"'
    alt-shift-s = 'exec-and-forget open -a "Slack"'
```

> **Note:** In AeroSpace config, the Option key is referred to as `alt`.


