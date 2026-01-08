# Troubleshooting Guide

## Quick Diagnostics

```bash
macarchy doctor    # Check all components
macarchy status    # Check if services are running
```

---

## Common Issues

### Borders Not Showing

**Symptoms:** No colored borders around windows

**Solutions:**

1. Check if borders is running:
   ```bash
   macarchy status
   ```

2. Manually start borders:
   ```bash
   source ~/.macarchy/config/theme.sh
   source ~/.macarchy/borders/config.sh
   borders active_color=$BORDER_ACTIVE inactive_color=$BORDER_INACTIVE width=$BORDER_WIDTH &
   ```

3. Check macOS version (borders requires 14.0+):
   ```bash
   sw_vers -productVersion
   ```

4. Reload Macarchy:
   ```bash
   macarchy restart
   ```

---

### Bar Not Appearing

**Symptoms:** SketchyBar not visible

**Solutions:**

1. Check if sketchybar is running:
   ```bash
   pgrep sketchybar
   ```

2. Manually start:
   ```bash
   sketchybar &
   ```

3. Check for errors:
   ```bash
   sketchybar 2>&1 | head -20
   ```

4. Verify config syntax:
   ```bash
   bash -n ~/.macarchy/sketchybar/sketchybarrc
   ```

---

### AeroSpace Not Tiling

**Symptoms:** Windows overlap instead of tiling

**Solutions:**

1. Check if AeroSpace is running:
   ```bash
   pgrep AeroSpace
   ```

2. Open AeroSpace app:
   ```bash
   open -a AeroSpace
   ```

3. Check config syntax:
   ```bash
   aerospace debug-config
   ```

4. Reload config:
   ```bash
   aerospace reload-config
   ```

---

### Symlinks Broken

**Symptoms:** `macarchy doctor` shows symlink errors

**Solutions:**

1. Re-run installer:
   ```bash
   cd ~/.macarchy
   ./install.sh
   ```

2. Manually fix symlinks:
   ```bash
   rm ~/.aerospace.toml
   ln -s ~/.macarchy/aerospace/aerospace.toml ~/.aerospace.toml
   
   rm ~/.config/sketchybar
   ln -s ~/.macarchy/sketchybar ~/.config/sketchybar
   ```

---

### Theme Changes Not Applying

**Symptoms:** Colors don't change after editing theme.sh

**Solutions:**

1. Always reload after changes:
   ```bash
   macarchy reload
   ```

2. Check theme file syntax:
   ```bash
   bash -n ~/.macarchy/config/theme.sh
   ```

3. Verify colors are exported:
   ```bash
   source ~/.macarchy/config/theme.sh
   echo $ACCENT  # Should print color value
   ```

---

### Services Don't Start at Login

**Symptoms:** Need to manually start Macarchy after reboot

**Solutions:**

1. Check login items:
   ```bash
   macarchy login status
   ```

2. Enable login:
   ```bash
   macarchy login enable
   ```

3. Verify in System Settings:
   - Open System Settings → General → Login Items
   - Check that AeroSpace is listed

---

### Bar Items Not Updating

**Symptoms:** Battery, time, or other items show stale data

**Solutions:**

1. Force update:
   ```bash
   sketchybar --update
   ```

2. Restart sketchybar:
   ```bash
   killall sketchybar
   sketchybar &
   ```

3. Check plugin scripts:
   ```bash
   ls -la ~/.macarchy/sketchybar/plugins/
   # All should be executable (-rwxr-xr-x)
   ```

4. Make plugins executable:
   ```bash
   chmod +x ~/.macarchy/sketchybar/plugins/*.sh
   ```

---

### `macarchy` Command Not Found

**Symptoms:** Terminal says "command not found: macarchy"

**Solutions:**

1. Source your shell config:
   ```bash
   source ~/.zshrc   # or ~/.bashrc
   ```

2. Check PATH:
   ```bash
   echo $PATH | grep macarchy
   ```

3. Add to PATH manually:
   ```bash
   export PATH="$HOME/.macarchy/bin:$PATH"
   ```

4. Re-run installer to fix PATH:
   ```bash
   cd ~/.macarchy
   ./install.sh
   ```

---

### Workspace Indicators Not Syncing

**Symptoms:** Bar shows wrong workspace as active

**Solutions:**

1. Trigger workspace event:
   ```bash
   sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
   ```

2. Check aerospace config has the event hook:
   ```bash
   grep "exec-on-workspace-change" ~/.macarchy/aerospace/aerospace.toml
   ```

3. Reload everything:
   ```bash
   macarchy restart
   ```

---

## Logs and Debugging

### View AeroSpace logs
```bash
log show --predicate 'subsystem == "bobko.aerospace"' --last 5m
```

### View SketchyBar output
```bash
# Start in foreground to see output
killall sketchybar
sketchybar
```

### Check system permissions
AeroSpace and borders may need accessibility permissions:
- System Settings → Privacy & Security → Accessibility
- Enable AeroSpace

---

## Reset to Defaults

If all else fails, reset Macarchy:

```bash
# Stop everything
macarchy stop

# Remove symlinks
rm ~/.aerospace.toml
rm ~/.config/sketchybar

# Re-run installer
cd ~/.macarchy
./install.sh
```

---

## Getting Help

1. Check the [README](../README.md)
2. Check the [Customization Guide](CUSTOMIZE.md)
3. Open an issue on GitHub


