# CLAUDE.md

This file provides guidance to Claude Code when working with this Linux dotfiles repository. It covers packages, their integrations, and common workflows.

## Repository Overview

This is a Linux dotfiles configuration repository using **stow** for symlink management. Each top-level directory (except `assets`) is a stow package containing configuration files for a specific application or service.

### Stow Package Structure

Stow packages follow this structure:
```
package-name/
  .config/
    app-name/
      config-files...
  .local/
    bin/
      scripts...
  .zshrc
  .tmux.conf
  etc.
```

When you run `stow package-name`, it creates symlinks in the home directory. For example, `stow zsh` symlinks `zsh/.zshrc` to `~/.zshrc`.

### Packages Overview

**Window Managers:**
- **hyprland** - Primary Wayland compositor with modular config files
- **niri** - Alternative column-based tiling WM using KDL syntax

**Shell & Prompt:**
- **zsh** - Shell with Zinit plugin manager, ASDF, and Starship integration
- **starship** - Cross-shell prompt with dynamic width-aware config switching
- **tmux** - Terminal multiplexer with TPM plugin system and Nord theme

**Status Bars & Panels:**
- **quickshell** - QML-based panel with bar, launcher, and wallpaper (primary)
- **waybar** - Wayland status bar with JSON config (alternative)
- **rofi** - Application launcher with window switcher

**Terminal Emulators:**
- **ghostty** - Modern terminal (primary) with Nord theme
- **alacritty** - GPU-accelerated terminal with TOML config
- **kitty** - Terminal with image protocol and dynamic opacity

**Tools:**
- **neovim** - LazyVim-based editor with modular plugins
- **yazi** - File manager with Lua plugins and Hyprland integration
- **dunst** - Notification daemon with Nord theme
- **wlogout** - Logout menu with power management

## Quick Start Guide

### Installing Packages with Stow

```bash
# Apply a single package
stow package-name

# Apply multiple packages
stow zsh tmux neovim

# Remove a package
stow -D package-name

# Check what would be symlinked (dry-run)
stow -n package-name

# Remove all packages
for dir in */; do [ "$dir" != "assets/" ] && stow -D "${dir%/}"; done
```

### First-Time Setup Checklist

1. **Clone dotfiles:** `git clone <repo> ~/.dotfiles && cd ~/.dotfiles`
2. **Stow essential packages:** `stow zsh starship tmux`
3. **Customize for hardware:**
   - Edit `hyprland/.config/hypr/conf/monitor.conf` (resolution, refresh rate, scaling)
   - Edit `hyprland/.config/hypr/conf/environments.conf` (GPU drivers)
   - Edit `hyprland/.config/hypr/conf/input.conf` (keyboard layout, mouse settings)
4. **Install fonts:** Sarasa Gothic Nerd Font via `aur/ttf-sarasa-gothic-nerd-fonts`
5. **Stow remaining packages:** `stow hyprland quickshell rofi ghostty dunst wlogout yazi neovim`
6. **Restart/login** to apply changes
7. **Verify:** Check symlinks with `ls -la ~/ && ls -la ~/.config/`

---

## Window Managers

### Hyprland (Primary)

Wayland compositor with modular configuration for display setup, keybindings, appearance, and window rules.

**Key files:** `hyprland/.config/hypr/conf/` (monitor.conf, binds.conf, decoration.conf, autostart.conf, general.conf, etc.)

**Hardware setup required:**
- Edit `conf/monitor.conf` for resolution/refresh rate (use `hyprctl monitors all` to list displays)
- Edit `conf/environments.conf` for GPU drivers (set LIBVA_DRIVER_NAME for AMD/NVIDIA)
- Edit `conf/input.conf` for keyboard layout and mouse settings

**Special workspaces:** `special:chat`, `special:music` (toggle via keybind)

**Integration:** Launches Quickshell/Waybar, Rofi, Ghostty, Yazi; controls wallpaper via hyprpaper

**Reload:** `hyprctl reload`

**Utility scripts:**
- `.scripts/reload-hyprpaper.sh` - Reload wallpaper daemon
- `.scripts/reload-quickshell.sh` - Restart Quickshell panel
- `.scripts/reload-waybar.sh` - Restart Waybar

---

### Niri (Alternative)

Column-based tiling WM using KDL (KDL Document Language) syntax.

**Key files:** `niri/.config/niri/config.kdl` (single config file, no modular splitting)

**Configuration patterns:**
- Keybinds: `bind "Super+KEY" { action; }`
- Columns: Primary layout unit; windows stack vertically within columns
- Workspaces: Virtual desktops accessible via `bind "Super+1" { show-workspace "ws-1"; }`

**Integration:** Use with alternative bars (Waybar); Quickshell currently Hyprland-specific

**Available actions:** `move-column-left/right`, `focus-column-left/right`, `move-window-down/up`, `toggle-fullscreen`, `close-window`, `spawn "command"`

---

## Shell & Prompt Environment

### Zsh

Shell configuration with Zinit plugin manager for auto-installation, ASDF version management, FZF, and Starship prompt integration.

**Key files:** `zsh/.zshrc` (main configuration)

**Features:**
- **Zinit:** Auto-installs on first run to `~/.local/share/zinit/`; loads plugins via `zinit light` or `zinit snippet OMZP::plugin-name`
- **ASDF:** Manages multiple language versions via `~/.tool-versions` files in project directories
- **Starship:** Dynamic prompt switching
- **History:** 10M entries with deduplication and cross-session sharing
- **Keybindings:** Emacs mode by default (`bindkey -e`); Vi mode available (`bindkey -v`)

**Integration:** Loaded by terminal emulators; sets up environment for zsh-based tools

**Reload:** `source ~/.zshrc` or open new terminal

---

### Starship

Cross-shell prompt with dynamic configuration switching based on terminal width.

**Key files:** `starship/.config/starship/starship.toml` (full), `starship_short.toml` (narrow terminals)

**Dynamic switching:** In zsh/.zshrc, `STARSHIP_CONFIG` env var switches between configs based on `COLUMNS` value (≥75 chars → full, <75 → short)

**Nord colors applied:** All modules use Nord palette for consistency

**Integration:** Receives COLUMNS from terminal; displays git info, language versions, status

**Reload:** Source zsh or start new terminal (auto-applied via precmd hook)

---

### Tmux

Terminal multiplexer with TPM (Tmux Plugin Manager) for plugin system and custom status bar scripts.

**Key files:** `tmux/.tmux.conf` (configuration and keybindings)

**Features:**
- **TPM:** Auto-installs on first run; manages plugin system
- **Status bar:** Custom scripts for uptime, load average, window list
- **Keybindings:** Vi-style navigation (C-a prefix; customize in config)
- **Copy mode:** Vi keybindings (`v` select, `y` copy, `C-a ]` paste)

**Integration:** Runs in terminal emulator; integrates with zsh, Neovim, file managers

**Reload:** Inside tmux: `C-a :source-file ~/.tmux.conf` | From shell: `tmux source-file ~/.tmux.conf`

**Scripts:** `~/.scripts/tmux-uptime.sh`, `tmux-loadavg.sh`, `tmux-update-status-right.sh`

---

## Status Bars & Panels

### Quickshell (Primary)

QML-based panel with integrated status bar, application launcher, and wallpaper management.

**Key files:** `quickshell/.config/quickshell/` (shell.qml, modules/bar/, modules/Launcher.qml)

**Components:**
- **Bar:** Clock, Audio, Battery, Network, Workspaces, Tray, MPRIS, Brightness
- **Launcher:** Fuzzy-searchable app list with Nord colors (main_bg, main_fg, etc.)
- **Program list:** `~/.scripts/quickshell-program-list.sh` generates JSON from system and Flatpak apps

**Integration:** Hyprland launcher toggle via `hyprctl dispatch exec "quickshell toggle appLauncher"`; system tray, MPRIS music players

**Reload:** `systemctl --user restart quickshell` or `killall quickshell && quickshell &`

**Color customization:** Edit `modules/Launcher.qml` colors property (hex values)

---

### Waybar (Alternative)

Wayland status bar with JSON config and CSS styling.

**Key files:** `waybar/.config/waybar/config.jsonc` (modules), `style.css` (styling)

**Built-in modules:** clock, pulseaudio/alsa, battery, network, hyprland/workspaces, hyprland/window, tray, custom scripts

**Integration:** Standalone status bar; works with Hyprland and other WMs

**Reload:** `killall waybar && waybar &`

**Custom scripts:** Create `~/.scripts/waybar-*.sh`, add to config with exec path and interval

---

### Rofi

Application launcher and window switcher with Nord theme using RASI configuration format.

**Key files:** `rofi/.config/rofi/config.rasi` (behavior), `theme.rasi` (styling)

**Available modes:** drun (launcher), run (shell commands), window (switcher), filebrowser (files)

**Integration:** Launched from Hyprland keybind (e.g., SUPER+SPACE); serves as alternative to Quickshell launcher

**Reload:** Test with `rofi -config ~/.config/rofi/config.rasi -show drun`

---

## Terminal Emulators

All terminals use **Sarasa Gothic Nerd Font** size 12, **Nord color palette**, **0.9 opacity** by default.

| Terminal | Config | Format | Key Features |
|----------|--------|--------|--------------|
| **Ghostty** (primary) | `config` | Key-value | Fastest startup, integrated Hyprland support |
| **Alacritty** | `alacritty.toml` | TOML | GPU-accelerated, copy-on-select, fallback fonts |
| **Kitty** | `kitty.conf` | Key-value | Image protocol, tmux integration, dynamic opacity |

**Common settings:** `background="#2e3440"`, `foreground="#d8dee9"`, `opacity=0.9`, `font-size=12`, `cursor-style=block`

**Integration:** All inherit zsh config; report COLUMNS for Starship prompt switching; set fonts and colors consistently

---

## Editor

### Neovim

LazyVim-based Neovim configuration with modular plugin management using lazy.nvim.

**Key files:** `neovim/.config/nvim/init.lua` (entry point), `lua/config/` (keymaps, options, autocmds), `lua/plugins/` (plugin specs)

**Plugin organization:** lazy.nvim manages plugins; `lazy-lock.json` pins exact versions for reproducibility

**Key commands:**
- `:Lazy sync` - Install/update plugins
- `:Mason` - Manage LSP servers
- `:TSInstall lang` - Install Treesitter parsers
- `:checkhealth` - Verify dependencies

**Integration:** Uses ripgrep (telescope), git CLI, LSP servers (mason.nvim), language tools

**Reload:** Changes apply on next editor start; some plugins require `:Lazy sync`

---

## Utilities

### Dunst

Notification daemon with Nord theme and application-specific rules.

**Key files:** `dunst/.config/dunst/dunstrc` (INI format)

**Configuration:**
- **[global]** - Global notification settings
- **[urgency_low/normal/critical]** - Appearance by urgency
- **[app-name]** - App-specific overrides

**Integration:** Displays system notifications from Hyprland, terminal apps, and services

**Reload:** `killall dunst && dunst &`

---

### Wlogout

Logout menu with power management buttons.

**Key files:** `wlogout/.config/wlogout/layout` (button definitions), `style.css` (styling), `icons/` (button images)

**Available actions:** `hyprctl dispatch exit` (logout), `systemctl poweroff`, `systemctl reboot`, `hyprlock` (lock), `systemctl suspend`

**Integration:** Launched from Hyprland keybind for system shutdown/logout

---

### Yazi

File manager with Lua plugin system and Hyprland integration.

**Key files:** `yazi/.config/yazi/yazi.toml` (behavior), `keymap.toml` (keybinds), `theme.toml` (colors), `plugins/` (Lua modules), `flavors/` (color schemes)

**Built-in plugins:** full-border, git (status display), smart-enter, smart-tab

**Integration:** Launched from Hyprland (SUPER+E); can trigger wallpaper changes via hyprctl

**Reload:** Restart Yazi to apply config changes

---

## Theme & Appearance

### Nord Color Palette

**Backgrounds:** nord0=#2e3440, nord1=#3b4252, nord2=#434c5e, nord3=#4c566a
**Text:** nord4=#d8dee9, nord5=#e5e9f0, nord6=#eceff4
**Accents:** nord7=#8fbcbb (cyan), nord8=#88c0d0 (blue, primary), nord9=#81a1c1, nord10=#5e81ac
**Status:** nord11=#bf616a (red), nord12=#d08770 (orange), nord13=#a3be8c (green), nord14=#b48ead (magenta)

### Font & Opacity

**Font:** Sarasa Gothic Nerd Font (install: `aur/ttf-sarasa-gothic-nerd-fonts`). Provides monospace, ligatures, and Nerd Font icons.

**Opacity:** Terminal/Dunst/Wlogout = 0.9 | WM decorations = fully opaque

---

## Cross-Package Integration

### Hyprland as Central Hub

Hyprland is the central integration point:

**Keybindings trigger apps:**
- `SUPER+RETURN` → Ghostty terminal
- `SUPER+SPACE` → Rofi launcher
- `SUPER+E` → Yazi file manager
- `SUPER+W` → Reload wallpaper

**Environment variables inherited by child processes:**
- `TERMINAL=ghostty`
- `EDITOR=nvim`
- `XDG_CURRENT_DESKTOP=Hyprland`

### Shell → Terminal → WM Relationships

1. **Hyprland keybinds** launch terminals
2. **Terminal** loads zsh from `~/.zshrc`
3. **Zsh** initializes Starship prompt (with dynamic config switching based on COLUMNS)
4. **Starship** displays git info, language versions, status in Nord colors
5. **All components** render with inherited fonts/colors for consistency

### Theme Consistency

Nord palette applied across:
- Hyprland (borders, notifications)
- Quickshell/Waybar (bar colors)
- Terminals (foreground/background)
- Neovim (colorscheme plugin)
- Dunst (notifications)
- Yazi (file manager)
- All utilities

### Script Integration

**Hyprland scripts** (in `.scripts/`):
- `reload-quickshell.sh` - Restart Quickshell panel
- `reload-waybar.sh` - Restart Waybar
- `reload-hyprpaper.sh` - Reload wallpaper daemon

**Quickshell scripts:**
- `quickshell-program-list.sh` - Generate app list for launcher (scans system and Flatpak apps)

**Tmux scripts:**
- `tmux-uptime.sh`, `tmux-loadavg.sh` - Status bar information

**Waybar scripts:**
- `waybar-calendar.sh`, `waybar-custom.sh` - Custom module updates

---

## Development Workflow

### Applying/Removing Configuration

```bash
# Apply packages
stow package-name
stow zsh tmux neovim starship

# Remove packages
stow -D package-name

# Dry-run
stow -n package-name

# Verify symlinks
ls -la ~/
ls -la ~/.config/
```

### Testing Configuration Changes

```bash
# Hyprland
hyprctl reload

# Quickshell
systemctl --user restart quickshell
# or
killall quickshell && quickshell &

# Waybar
killall waybar && waybar &

# Tmux (inside session)
C-a :source-file ~/.tmux.conf
# or from shell
tmux source-file ~/.tmux.conf

# Zsh
source ~/.zshrc

# Neovim
:Lazy sync  (in editor)

# Terminals
# Auto-reload on config change; no action needed
```

### Debugging Tips

**Hyprland:** `hyprctl monitors all`, `hyprctl clients`, `hyprctl workspaces`, `journalctl -xe | grep hyprland`

**Quickshell:** `~/.scripts/quickshell-program-list.sh | jq .`, `systemctl --user status quickshell`

**Tmux:** `~/.scripts/tmux-uptime.sh`

**Zsh:** `ZINIT[VERBOSE]=1 source ~/.zshrc`, `echo $PATH`, `asdf list`

**Neovim:** `:Lazy`, `:checkhealth`, `:Lazy profile`

---

## Common Workflows

### Setting Up a New Machine

1. **Clone dotfiles:** `git clone <repo> ~/.dotfiles && cd ~/.dotfiles`

2. **Install essential packages:**
   ```bash
   pacman -S zsh tmux neovim ghostty
   pacman -S hyprland quickshell rofi dunst
   pacman -S noto-fonts-cjk noto-fonts-emoji
   yay -S ttf-sarasa-gothic-nerd-fonts
   ```

3. **Stow core packages:** `stow zsh starship tmux && source ~/.zshrc`

4. **Customize hardware:**
   - `hyprland/.config/hypr/conf/monitor.conf`
   - `hyprland/.config/hypr/conf/environments.conf`
   - `hyprland/.config/hypr/conf/input.conf`

5. **Stow remaining:** `stow hyprland quickshell rofi ghostty dunst wlogout yazi neovim`

6. **Test:** Restart/login and verify symlinks

### Switching Window Managers

**Hyprland → Niri:**
1. `stow niri`
2. `stow -D hyprland`
3. Update Quickshell/Waybar configs if needed (WM-specific)
4. Logout and select Niri session

**Niri → Hyprland:**
1. `stow hyprland`
2. `stow -D niri`
3. Logout and select Hyprland session

Note: Quickshell/Waybar are Hyprland-specific due to workspace/window detection.

### Switching Status Bars

**Quickshell → Waybar:**
1. `stow waybar`
2. Update Hyprland keybindings
3. `killall quickshell`

**Waybar → Quickshell:**
1. Quickshell already stowed
2. `killall waybar`
3. `systemctl --user restart quickshell`

### Global Color Scheme Changes

To switch color schemes across all apps:

1. Choose new palette (e.g., Dracula)
2. Update: `hyprland/conf/general.conf` (borders), `hyprland/conf/decoration.conf` (decorations), `starship.toml`, `tmux/.tmux.conf`, `rofi/theme.rasi`, terminal configs, `dunst/dunstrc`, `yazi/flavors/`
3. Reload: `hyprctl reload && source ~/.zshrc && tmux source-file ~/.tmux.conf && killall dunst && dunst &`

### Adding New Keybindings

| Component | File | Syntax | Reload |
|-----------|------|--------|--------|
| **Hyprland** | `conf/binds.conf` | `bind = $mainMod, KEY, action` | `hyprctl reload` |
| **Tmux** | `.tmux.conf` | `bind KEY action` | `C-a :source-file ~/.tmux.conf` |
| **Zsh** | `.zshrc` | `bindkey "key" action` | `source ~/.zshrc` |
| **Niri** | `config.kdl` | `bind "Super+KEY" { action; }` | Restart Niri |
| **Yazi** | `keymap.toml` | `[[mgr.prepend_keymap]] on = "key"` | Restart Yazi |
| **Neovim** | `lua/config/keymaps.lua` | `vim.keymap.set(...)` | Next start |

---

## Troubleshooting

### Window Manager Issues

**Hyprland won't start:**
- Check logs: `journalctl -xe | grep hyprland`
- Verify GPU drivers installed
- Test config: `hyprctl reload` from TTY
- Check dependencies: wayland, libxcb, gcc

**Niri won't start:**
- Verify installed: `niri --version`
- Check XDG session support
- Validate KDL syntax in config.kdl

### Bar/Panel Issues

**Quickshell not launching:**
- Status: `systemctl --user status quickshell`
- Logs: `journalctl --user -xe | grep quickshell`

**Waybar not appearing:**
- Run foreground: `waybar &` (see output)
- Check config.jsonc JSON syntax
- Verify modules configured

**Rofi not responding:**
- Test: `rofi -show drun`
- Check theme exists
- Verify `terminal = "ghostty"` in config

### Terminal Issues

**Terminal won't open from Hyprland:**
- Check keybinding correct (SUPER+RETURN)
- Verify binary exists: `which ghostty`

**Font rendering issues:**
- Verify Sarasa installed: `fc-list | grep Sarasa`
- Restart terminal after font install

**Transparency not working:**
- Hyprland supports opacity natively
- Check opacity syntax in terminal config

### Shell/Prompt Issues

**Starship not switching configs:**
- Check `COLUMNS`: `echo $COLUMNS`
- Verify configs exist: `ls ~/.config/starship*.toml`
- Check `set_starship_config_precmd` in .zshrc

**Zinit plugins not loading:**
- Debug: `ZINIT[VERBOSE]=1 source ~/.zshrc`
- Verify dir: `ls ~/.local/share/zinit/`

**ASDF version switching not working:**
- Check `.tool-versions` format (one per line)
- Verify installed: `asdf list nodejs`
- Check PATH order: `echo $PATH | tr ':' '\n' | head -5`

---

## Important Notes

- **Hardware setup required:** Before first Hyprland use, customize monitor.conf and environments.conf
- **Font requirement:** Sarasa Gothic Nerd Font via `aur/ttf-sarasa-gothic-nerd-fonts`
- **Modular approach:** Keep configs in their own packages; minimize cross-package dependencies
- **.stow-local-ignore:** Prevents CLAUDE.md from being symlinked to home
- **Backup before changes:** Create backups for critical configs
- **Test in isolation:** Debug individual components before blaming integration

---

## File Path Reference

**Commonly Modified Directories:**
- `hyprland/.config/hypr/conf/` - Modular Hyprland configs
- `quickshell/.config/quickshell/` - QML modules for bar/launcher
- `zsh/.zshrc` - Shell configuration
- `neovim/.config/nvim/` - Neovim with lua/config and lua/plugins
- `tmux/.tmux.conf` - Terminal multiplexer config
- `starship/` - Starship configs (starship.toml, starship_short.toml)
- `rofi/.config/rofi/` - Rofi launcher config
- `dunst/.config/dunst/dunstrc` - Notification daemon config
- `wlogout/.config/wlogout/` - Logout menu config
- `yazi/.config/yazi/` - File manager config with keymaps and themes

---

**This documentation provides essential information for working with this dotfiles repository. Refer to sections above or search (Ctrl+F) for specific topics.**
