# CLAUDE.md

This file provides comprehensive guidance to Claude Code when working with this Linux dotfiles repository. It covers all packages, their configurations, integration points, and common workflows.

## Repository Overview

This is a Linux dotfiles configuration repository using **stow** for symlink management. Each top-level directory (except `assets`) is a stow package containing configuration files for a specific application or service.

### Stow Package Structure

Stow packages use this structure:
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

When you run `stow package-name`, it creates symlinks in the home directory according to this structure. For example, `stow zsh` symlinks `zsh/.zshrc` to `~/.zshrc`.

### Packages Overview

**Window Managers & Compositors:**
- **hyprland** - Primary Wayland compositor with modular conf files (monitor, input, keybinds, etc.)
- **niri** - Alternative column-based tiling window manager using KDL syntax

**Shell & Prompt:**
- **zsh** - Shell configuration with Zinit plugin manager, ASDF, fzf, and Starship prompt integration
- **starship** - Cross-shell prompt with dynamic config switching (full vs. short based on terminal width)
- **tmux** - Terminal multiplexer with TPM plugin system, Nord color theme, and custom status scripts

**Status Bars & Panels:**
- **quickshell** - QML-based shell/panel with integrated bar, launcher, and wallpaper management (primary)
- **waybar** - Wayland status bar with JSON config and CSS styling (alternative)
- **rofi** - Application launcher with RASI config and window switcher

**Terminal Emulators:**
- **ghostty** - Modern terminal (primary) with Nord custom theme
- **alacritty** - GPU-accelerated terminal with TOML config
- **kitty** - Terminal with image protocol support and dynamic opacity

**Editor & Tools:**
- **neovim** - LazyVim-based Neovim with modular plugin organization
- **yazi** - File manager with Lua plugin system and Hyprland wallpaper integration

**Utilities:**
- **dunst** - Notification daemon with urgency levels and app-specific rules
- **wlogout** - Logout menu with configurable actions and styling

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
2. **Stow essential packages:**
   ```bash
   stow zsh starship tmux
   ```
3. **Customize for your hardware:**
   - Edit `hyprland/.config/hypr/conf/monitor.conf` (resolution, refresh rate, scaling)
   - Edit `hyprland/.config/hypr/conf/environments.conf` (GPU drivers if NVIDIA)
   - Edit `hyprland/.config/hypr/conf/input.conf` (keyboard layout, mouse settings)
4. **Install fonts:** Sarasa Gothic Nerd Font via `aur/ttf-sarasa-gothic-nerd-fonts` or manually
5. **Stow remaining packages:** `stow hyprland quickshell rofi ghostty dunst wlogout yazi`
6. **Restart/login** to apply WM and shell changes
7. **Verify:** Check that symlinks are created with `ls -la ~/` (see .zshrc, .tmux.conf, .config/hypr, etc.)

### Testing Configuration Changes

Most changes take effect with reload/restart:
- **Hyprland:** Reload with `hyprctl reload` or keybind
- **Quickshell:** `systemctl --user restart quickshell` or `killall quickshell && quickshell &`
- **Waybar:** `killall waybar && waybar &`
- **Tmux:** `:source-file ~/.tmux.conf` within tmux session
- **Zsh:** `source ~/.zshrc` or start new shell
- **Neovim:** Changes apply on next editor start
- **Other configs:** Usually reload/restart required

---

## Window Managers

### Hyprland (Primary)

Hyprland window manager with modular configuration files, custom keybindings, and integration with supporting services.

#### Architecture

The configuration is split into modular conf files under `hyprland/.config/hypr/conf/`:

- **monitor.conf** - Display/monitor settings (resolution, refresh rate, position, scaling)
- **autostart.conf** - Services/apps launched on WM start
- **input.conf** - Keyboard and mouse configuration (XKB options, touchpad, mouse settings)
- **environments.conf** - Environment variables (GPU drivers, XDG desktop, scaling factors)
- **general.conf** - Core WM behavior (gaps, border, layout, focus policy)
- **decoration.conf** - Window decorations, shadows, rounding, blur effects
- **animations.conf** - Animation curves and durations for window actions
- **layouts.conf** - Master, dwindle, and layout-specific configs
- **gestures.conf** - Touchpad and mouse gesture bindings
- **misc.conf** - Miscellaneous settings (damage tracking, VFR, font, etc.)
- **windowrules.conf** - Rules for specific windows (floating, workspace assignment, sizing)
- **layerrules.conf** - Rules for protocol layers (keyboard interactive, opacity)
- **binds.conf** - All keyboard and mouse bindings

These are sourced from the main `hyprland.conf` (lives at `~/.config/hypr/hyprland.conf` after stow).

#### Key Settings & Patterns

**Keybinding Conventions:**
- `$mainMod = SUPER` - Primary modifier for shortcuts
- `SUPER + arrow keys` - Focus movement and window resizing
- `SUPER SHIFT + arrows` - Move windows between positions
- `SUPER CTRL + arrows` - Resize windows
- `XF86 keys` - Hardware audio, brightness, WiFi (use `bindl` for listen binds that work while locked)

**Special Workspaces:**
- `special:chat` - Quick chat workspace (toggle visibility)
- `special:music` - Music player with dedicated layout
- Access via `hyprctl dispatch togglespecialworkspace <name>`

**Scripts in .scripts/:**
- `reload-hyprpaper.sh` - Reload wallpaper daemon
- `reload-quickshell.sh` - Restart Quickshell panel
- `reload-waybar.sh` - Reload Waybar (if using instead of Quickshell)

#### Hardware-Specific Setup

Before first use, customize:

1. **monitor.conf** - Set correct resolution, refresh rate, position:
   ```
   monitor=DP-1,1920x1080@144,0x0,1
   monitor=HDMI-1,1920x1080@60,1920x0,1
   ```
   Use `hyprctl monitors all` to list connected displays.

2. **environments.conf** - GPU drivers:
   ```
   env = LIBVA_DRIVER_NAME,radeonsi  # For AMD
   env = LIBVA_DRIVER_NAME,nvidia    # For NVIDIA (also set NVIDIA env vars)
   ```

3. **input.conf** - Keyboard layout, mouse settings (XKB options, acceleration)

#### Performance Tuning

- `VFR` in misc.conf - Variable frame rate (disable if experiencing tearing)
- `damage_tracking` - "full" for lower latency, "none" for stability
- `no_cursor_warps` - Disable cursor warp to prevent input lag

#### Integration Points

- **Quickshell** - App launcher and panel (triggered via keybind, receives IPC commands)
- **Waybar** - Alternative status bar (config included, switch via reload scripts)
- **Rofi** - Application launcher (SUPER+SPACE)
- **Ghostty/Kitty/Alacritty** - Terminal (SUPER+RETURN)
- **Yazi** - File manager (SUPER+E, floating window)
- **Hyprpaper** - Wallpaper daemon

#### Common Hyprland Tasks

**Add a New Keybinding:**
Edit `conf/binds.conf`:
```
bind = $mainMod, KEY, action-or-command
bindl = , XF86_KEY, action       # Listen binds for always-listening keys
binde = $mainMod, KEY, resizeactive, dx dy  # Repeat-able binds
```

**Reload Configuration:**
```
hyprctl reload
# or via keybind: Right-click bar → Reload
```

**Change Wallpaper:**
Update path in `hyprpaper.conf`, then run `hyprctl dispatch exec ~/.scripts/reload-hyprpaper.sh`

**Switch Between Layouts:**
```
hyprctl dispatch layoutmsg togglesplit
```

**Debug Window Issues:**
```
hyprctl clients        # List windows and get class names
hyprctl monitors all   # Check monitor setup
hyprctl activewindow   # Get active window info
```

---

### Niri (Alternative)

Niri is a column-based tiling window manager using KDL (KDL Document Language) syntax.

#### Architecture

Niri uses a single configuration file with KDL syntax:
- **config.kdl** - Single config file (no modular splitting)
- KDL syntax uses nested blocks with property assignments
- Configuration groups: input, layouts, actions, keybindings, decorations, etc.

Key concepts:
- **Columns** - Primary layout unit; windows stack vertically within columns
- **Workspaces** - Virtual desktops for organizing windows
- **Gestures** - Touchpad/mouse gesture handling
- **Actions** - Commands executable via keybindings

#### Key Configuration Patterns

**Input Configuration:**
```kdl
input {
    keyboard {
        xkb {
            options "ctrl:nocaps"  // Remap Caps Lock to Ctrl
        }
        repeat-delay 250
    }
    touchpad {
        tap
        natural-scroll
    }
    focus-follows-mouse max-scroll-amount="0%"
    warp-mouse-to-focus
}
```

**Keybinding Patterns:**
```kdl
bind "Super+Q" { close-window; }
bind "Super+H" { move-column-left; }
bind "Super+J" { focus-window-down; }
bind "Super+K" { focus-window-up; }
bind "Super+L" { move-column-right; }
bind "Super+Return" { spawn "ghostty"; }
```

**Workspace Configuration:**
```kdl
workspace "workspace-1" { }
workspace "workspace-2" { }

bind "Super+1" { show-workspace "workspace-1"; }
bind "Super+2" { show-workspace "workspace-2"; }
```

**Window Decorations:**
```kdl
decoration {
    border-width 2
    active-color "#8fbcbb"
    inactive-color "#434c5e"
}
```

#### Available Actions

- `move-column-left/right` - Navigate columns
- `move-window-down/up` - Reorder windows in column
- `focus-column-left/right` - Focus adjacent column
- `focus-window-down/up` - Focus adjacent window in same column
- `toggle-fullscreen` - Fullscreen current window
- `close-window` - Close focused window
- `spawn command` - Execute external command
- `toggle-floating-window` - Floating mode
- `resize-column-left/right` - Column width adjustment

#### Column-Based Tiling

Unlike Hyprland's flexible layouts, Niri primarily uses columns:
- New windows open in current column (stacked vertically)
- Move windows between columns horizontally
- Resize columns or individual window heights
- Tiles adapt to available space automatically

#### Comparison with Hyprland

| Aspect | Niri | Hyprland |
|--------|------|----------|
| Config language | KDL | Conf with source includes |
| Tiling model | Column-based | Flexible (dwindle, master, etc.) |
| Configuration split | Single file | Multiple modular files |
| Learning curve | Moderate | Moderate |
| Maturity | Newer | More established |
| Customization | Good | Very high |

#### Common Niri Tasks

**Add a Keybinding:**
```kdl
bind "Super+X" { spawn "command-to-run"; }
```

**Set Column Width:**
```kdl
bind "Super+Control+H" { resize-column-left 100; }
bind "Super+Control+L" { resize-column-right 100; }
```

**Move Window to Workspace:**
```kdl
bind "Super+Shift+1" { move-window-to-workspace "workspace-1"; }
```

---

## Shell & Prompt Environment

### Zsh

Shell configuration with Zinit plugin manager, ASDF version management, and dynamic Starship prompt switching.

#### Architecture (Layered)

1. **Core Shell Options** - Keybindings, history, editor setup
2. **Zinit Bootstrap** - Auto-installs Zinit plugin manager on first run
3. **Annexes** - Zinit extensions for enhanced plugin loading
4. **OMZ Snippets** - Select plugins from Oh-My-Zsh repository
5. **Starship Prompt** - Dynamic prompt with terminal width-aware config switching
6. **ASDF** - Version manager for multiple languages (installed via Zinit)
7. **FZF Integration** - Fuzzy finder for history and file search
8. **Custom Bindings** - Additional keybindings and utility functions

#### Zinit Plugin Manager

**Installation:**
- First run checks `$ZINIT_HOME` (defaults to `~/.local/share/zinit/zinit.git`)
- Auto-clones Zinit repository if missing
- Subsequent runs load Zinit from cache

**Plugin Loading Patterns:**
```zsh
# Light-mode plugins (no reporting overhead)
zinit light user/plugin

# Snippet from OMZ
zinit snippet OMZP::plugin-name

# Annexes (extensions for Zinit)
zinit light-mode for \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node
```

**Annexes Included:**
- `annex-readurl` - Use URLs as plugin specs
- `annex-bin-gem-node` - Expose bin/ directories to PATH
- `annex-patch-dl` - Apply patches during installation
- `annex-rust` - Install Rust binaries

#### Starship Prompt Switching

Dynamic switching based on terminal width (COLUMNS):
- **<75 columns** - Load `~/.config/starship_short.toml` (minimal for narrow terminals)
- **≥75 columns** - Load `~/.config/starship.toml` (full with all modules)

Implemented via `set_starship_config_precmd()` hook that runs before each prompt display, allowing seamless adaptation when terminal is resized.

#### ASDF Integration

ASDF (Another System Definition Format) manages multiple language versions:
- Installed on first run via Zinit
- Provides `asdf` command for version switching
- Reads `.tool-versions` files in project directories
- Supports Node.js, Python, Ruby, Go, Rust, Java, and many others

#### History Configuration

- **Size** - 10 million entries (HISTSIZE, SAVEHIST)
- **Deduplication** - HIST_IGNORE_DUPS removes consecutive duplicates
- **Sharing** - appendhistory, sharehistory enable cross-session sharing
- **Filtering** - HIST_IGNORE_SPACE ignores commands starting with space
- **Reduction** - HIST_REDUCE_BLANKS removes extra whitespace

#### Keybindings & PATH

**Keybindings:**
- **Emacs mode** - Default (`bindkey -e`)
- **Ctrl+H** - Kill previous word (instead of backspace behavior)
- Vi mode available with `bindkey -v`

**PATH Management:**
- `~/.local/bin` - User scripts (added first, takes priority)
- `$PNPM_HOME` - pnpm package manager (if installed)
- Deduplication via `typeset -U path` prevents duplicates

#### Common Zsh Tasks

**Install a New Plugin:**
```zsh
# Add to zsh/.zshrc after Zinit bootstrap
zinit light author/plugin-name
# or from OMZ:
zinit snippet OMZP::plugin-name

# Then reload:
source ~/.zshrc
```

**Switch ASDF Language Version:**
Create `.tool-versions` in project directory:
```
nodejs 18.0.0
python 3.10.0
```
Then run: `asdf install`

**Check ASDF Versions:**
```bash
asdf current          # Current versions in use
asdf list nodejs      # Installed Node.js versions
asdf list all nodejs  # All available versions
asdf install nodejs latest  # Install latest
```

**Switch to Vi Keybindings:**
Edit `zsh/.zshrc`, comment out `bindkey -e` and add `bindkey -v`

---

### Starship

Cross-shell prompt with dynamic configuration switching based on terminal width.

#### Architecture

Two TOML configuration files with dynamic switching via environment variable:
- **starship.toml** - Full prompt configuration for normal-width terminals (≥75 columns)
- **starship_short.toml** - Minimal prompt for narrow terminals (<75 columns)
- Dynamic switching via `STARSHIP_CONFIG` environment variable in zsh/.zshrc

#### Configuration Structure

Both TOML files define:
- **[format]** - Overall prompt structure (which modules to show, in what order)
- **[module-name]** - Configuration for specific modules (versions, icons, colors)
- **Global options** - Colors, scan timeout, line-break behavior

#### Module Categories

**Language Detection:**
- Shows current language/framework version (rust, node, python, go, etc.)
- Auto-detects presence of language files (Cargo.toml, package.json, requirements.txt, etc.)

**Git Integration:**
- Branch name, commit status, modifications
- Color changes based on status (clean = green, dirty = red)

**System Info:**
- Username, hostname, time, shell type

**Directory Info:**
- Current path with truncation

**Status Indicators:**
- Last command exit code, color changes on error

#### Full vs. Short Configuration

**Full Configuration (starship.toml):**
Intended for wider displays:
- Shows language versions (Node.js, Python, Rust, Go, etc.)
- Includes git branch and status
- Displays time, username, hostname
- Shows command exit status (color-coded)
- Full directory path (with truncation)

**Short Configuration (starship_short.toml):**
Minimalist variant for narrow terminals:
- Omits language version detectors
- Minimal git info
- No time or system info
- Single-line prompt with core navigation info
- Faster rendering (fewer modules)

#### Nord Color Palette

Both configs use Nord colors for consistency:
- Nord0-3: Dark backgrounds
- Nord4-6: Light backgrounds/text
- Nord7-10: Accent colors for different statuses
- Nord11: Error/failure (red)
- Nord12: Warning (orange)
- Nord13: Success (green)
- Nord14: Info (cyan)
- Nord15: Special (magenta)

Applied via `style = "fg:nord7"` in module configurations.

#### Common Starship Tasks

**Customize Prompt Format:**
Edit appropriate TOML file:
```toml
[format]
format = "..."  # Change order/content of modules
```

**Change Module Colors:**
```toml
[directory]
style = "bold cyan"
format = "[$path]($style) "
```

**Add Language Version Detection:**
```toml
[golang]
symbol = "🐹 "
style = "bold blue"
format = "[$symbol$version]($style) "
disabled = false
```

**Hide Specific Module:**
```toml
[git_status]
disabled = true
```

**Test Configuration:**
```bash
starship config         # Check syntax
starship print-config   # Preview with current settings
starship module directory  # Test specific module
```

---

### Tmux

Terminal multiplexer with TPM plugin system, custom status bar scripts, and Vi-style keybindings.

#### Architecture

- **.tmux.conf** - Main configuration (keybindings, options, colors)
- **.scripts/** - Helper scripts for status line updates
- **TPM** - Tmux Plugin Manager for extending functionality

Key components:
- Status bar with time, load, uptime, window list
- Vi-style keybindings for pane/window navigation
- Pane split management and arrangement
- Nord color theme throughout

#### TPM (Tmux Plugin Manager)

TPM auto-installs on first run:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Plugin definition in .tmux.conf:
```tmux
set -g @plugin 'author/repo'
run '~/.tmux/plugins/tpm/tpm'
```

Standard plugins include:
- **tmux-plugins/tmux-sensible** - Sensible defaults
- **dracula/tmux** or Nord theme - Color scheme
- Custom local scripts in .scripts/

#### Status Bar Scripts

Located in **.scripts/**, designed for status line display:

- **tmux-uptime.sh** - System uptime display (days, hours, minutes)
- **tmux-loadavg.sh** - Load average display with color-coding
- **tmux-update-status-right.sh** - Main status line updater orchestrating script execution

#### Keybinding Conventions

Tmux uses prefix key (default C-b, commonly remapped to C-a):

```tmux
# Navigation (Vi-style)
bind h select-pane -L       # Move left
bind j select-pane -D       # Move down
bind k select-pane -U       # Move up
bind l select-pane -R       # Move right

# Window management
bind c new-window
bind & kill-window
bind q close-session

# Pane splitting and resizing
bind v split-window -h      # Split vertically
bind s split-window -v      # Split horizontally
bind < resize-pane -L 10    # Resize left
bind > resize-pane -R 10    # Resize right
bind - resize-pane -D 5     # Resize down
bind + resize-pane -U 5     # Resize up
```

#### Copy Mode (Vi Keybindings)

```tmux
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection
```

- `v` - Begin selection
- `y` - Copy selection
- `Shift+Insert` or `C-]` - Paste

#### Configuration Notes

**Prefix Key Customization:**
Default is C-b. Common remapping to C-a:
```tmux
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

**Mouse Support:**
```tmux
set -g mouse on
```

Allows click to focus panes/windows, drag to resize, scroll in history.

**Color Scheme:**
Nord theme applied via TPM plugin or manual color definitions in .tmux.conf.

#### Integration Points

- **Terminal emulator** - Runs inside Alacritty, Ghostty, or Kitty
- **Shell** - Executes zsh commands in panes, inherits shell config
- **Vim/Neovim** - Integrates with editor via keybindings
- **File managers** - Ranger/Yazi launched in popup windows
- **System tools** - Htop/btop, custom scripts

#### Common Tmux Tasks

**Create a New Session:**
```bash
tmux new-session -s session-name
# or within Tmux:
C-a :new-session -s name
```

**Navigate Panes:**
```bash
C-a h  # Focus left
C-a j  # Focus down
C-a k  # Focus up
C-a l  # Focus right
```

**Split Windows:**
```bash
C-a v  # Vertical split (side by side)
C-a s  # Horizontal split (top/bottom)
```

**Copy and Paste:**
```bash
C-a [  # Enter copy mode
v      # Begin selection (vi mode)
y      # Copy selection
C-a ]  # Paste
```

**Reload Configuration:**
```bash
C-a :source-file ~/.tmux.conf
```

**Enable Kitty Image Protocol:**
```tmux
set -g allow-passthrough on
```

---

## Status Bars & Panels

### Quickshell (Primary)

QML-based shell/panel with integrated status bar, application launcher, and wallpaper management.

#### Architecture

Quickshell uses Qt/QML with per-screen design:
- **shell.qml** - Main entry point (ShellRoot) that creates bar and launcher per screen
- **modules/bar/** - Bar components (Clock, Audio, Battery, Network, Workspaces, Tray, Mpris, Brightness, etc.)
- **modules/Launcher.qml** - Fuzzy-searchable application launcher
- **modules/Wallpaper.qml** - Wallpaper setter integrated into shell
- **.scripts/quickshell-program-list.sh** - Helper script generating JSON list of apps

#### QML Execution Model

- **ShellRoot** - Top-level container creating WindowManager instances
- **Variants** - Iterates over `Quickshell.screens` to create bar/launcher per display
- **Scope** - Provides per-screen state and access to `modelData` (current screen)
- **PanelWindow** (Launcher) - Full-screen overlay for launcher, toggled via IPC

#### IPC Communication

Quickshell receives commands via `IpcHandler`:
- `appLauncher` target handles `toggle()` and `close()` functions
- Called from Hyprland keybindings: `hyprctl dispatch exec "quickshell toggle appLauncher"`

#### Launcher Module Details

The launcher implements fuzzy search with:
- `allApps` - Complete list of available apps (parsed from .desktop files)
- `filteredApps` - Results matching current query via fuzzy matching
- `selectedIndex` - Current keyboard selection (0-based)
- **Nord color palette** - Predefined colors (main_bg, main_fg, entry_bg, select_bg, etc.)

Fuzzy algorithm:
- Scores matches based on character positions and gaps
- Prefers prefix matches and consecutive characters
- Case-insensitive, handles accents

#### Program List Script

**.scripts/quickshell-program-list.sh** generates JSON array:
```json
[
  {"name": "App Name", "icon": "icon-name", "exec": "command"},
  ...
]
```

Sources from:
- System .desktop files in `/usr/share/applications/`, `~/.local/share/applications/`
- Flatpak apps via `flatpak list --app --columns=application,name` (if installed)
- Filters duplicates, respects NoDisplay flag

#### Bar Modules

Each module in `modules/bar/` is a QML component:
- **Clock.qml** - Time display with configurable format
- **Audio.qml** - Volume slider and audio source indicator
- **Battery.qml** - Battery percentage and charging status
- **Network.qml** - WiFi/ethernet status and connectivity
- **Workspaces.qml** - Hyprland workspace indicators (IPC communication)
- **SpecialWorkspaces.qml** - Custom special workspace widgets
- **Tray.qml** - System tray for notification icons
- **Mpris.qml** - Music player controls (play/pause, track info)
- **Brightness.qml** - Screen brightness control
- **ActiveWindowDisplay.qml** - Title of currently focused window

Each module can be individually enabled/disabled in Bar.qml.

#### Configuration Notes

**Color Customization:**
Edit `modules/Launcher.qml`, modify the `colors` property object:
```qml
readonly property var colors: ({
    "main_bg": "#2e3440",
    "main_fg": "#d8dee9",
    ...
})
```

**Performance Considerations:**
- Program list script runs once on startup (can be slow with many Flatpak apps)
- Consider caching JSON if script is slow
- Fuzzy matching happens on every keystroke

#### Integration Points

- **Hyprland** - Receives keybind events and IPC commands, controls wallpaper via hyprctl
- **Wallpaper daemon** - Uses hyprctl or direct wallpaper daemon control
- **System tray** - Integrates with D-Bus for status icons
- **MPRIS** - Integrates with music players (playerctl backend)
- **Terminal** - Launcher executes selected app with terminal preference if needed

#### Common Quickshell Tasks

**Add a Bar Widget:**
1. Create new QML file in `modules/bar/` (e.g., NewWidget.qml)
2. Define a Rectangle-based component with property bindings
3. Import necessary Quickshell modules (`Quickshell.Io` for processes, etc.)
4. Import and instantiate in Bar.qml layout

**Customize Launcher Colors:**
Edit `modules/Launcher.qml`:
```qml
readonly property var colors: ({
    "main_bg": "#RRGGBB",
    "main_fg": "#RRGGBB",
    ...
})
```

**Test Launcher Visibility:**
```bash
quickshell --socket /run/user/1000/quickshell-0 --toggle-window appLauncher
```

**Debug Program List:**
```bash
~/.scripts/quickshell-program-list.sh | jq .
```

**Reload Quickshell:**
```bash
systemctl --user restart quickshell
# or
killall quickshell && quickshell &
```

---

### Waybar (Alternative)

Wayland status bar with vertical layout, grouped drawer modules, and custom script integrations.

#### Architecture

Waybar uses JSON-based configuration and CSS styling:
- **config.jsonc** - Module definitions, positioning, formatting, click/scroll actions
- **style.css** - Styling for modules, colors, fonts, animations, theme
- **.scripts/** - Helper scripts for dynamic module updates

#### Configuration Structure

config.jsonc defines:
- **position** - Bar placement (top, bottom, left, right)
- **height/width** - Bar dimensions
- **modules-left/center/right** - Module layout and ordering
- **module-specific settings** - Each module's configuration options

#### Built-in Modules

- **clock** - Date/time display with click to open calendar
- **custom/...** - Custom scripts or commands
- **pulseaudio/alsa** - Audio control
- **battery** - Battery status and percentage
- **network** - Wired/wireless connectivity
- **hyprland/workspaces** - Workspace indicators for Hyprland
- **hyprland/window** - Active window title
- **tray** - System tray icons
- **bluetooth** - Bluetooth device status

#### Custom Modules

Created with `"custom/module-name"` in config:
```json
"custom/calendar": {
  "format": "📅 {}",
  "exec": "~/.scripts/waybar-calendar.sh",
  "on-click": "command-to-open-calendar",
  "interval": 60
}
```

#### Scripts Integration

Scripts in .scripts/:
- **waybar-calendar.sh** - Displays calendar date, optionally opens date picker
- **waybar-calendar-internal.sh** - Helper script for date calculations

Scripts return:
- Plain text for `"custom/..."` modules
- JSON with `{text, tooltip, class}` for advanced updates
- Exit code 33 for icon rotation (useful for loading states)

#### Styling Approach

**style.css** uses selectors for each module:
```css
window {
  background-color: #2e3440;
  color: #eceff4;
}

#modules, #clock {
  margin: 4px 8px;
}

#custom-calendar {
  padding: 0 8px;
}
```

CSS handles colors, spacing, fonts, borders, animations.

#### Workspace Indicators

For Hyprland integration:
```json
"hyprland/workspaces": {
  "format": "{name}",
  "on-click": "activate",
  "persistent-workspaces": {
    "1": ["DP-1"],
    "2": ["DP-1"]
  }
}
```

#### Comparison with Quickshell

| Aspect | Waybar | Quickshell |
|--------|--------|-----------|
| Configuration | JSON + CSS | QML |
| Customization | Moderate (CSS styling) | High (full QML) |
| Learning curve | Lower (familiar JSON/CSS) | Higher (needs QML knowledge) |
| App launcher | Via Rofi separately | Integrated |
| Wallpaper | Via script | Integrated |
| Performance | Lightweight | More resource-heavy |

#### Common Waybar Tasks

**Add a New Module:**
```json
"modules-center": [
  "clock",
  "custom/new-module"
],
"custom/new-module": {
  "format": "Icon {}",
  "exec": "~/.scripts/new-module.sh",
  "interval": 30
}
```

**Create Custom Script Module:**
1. Create script: `~/.scripts/waybar-custom.sh`
2. Make executable: `chmod +x ~/.scripts/waybar-custom.sh`
3. Add to config with path and interval

**Reload Waybar:**
```bash
killall waybar && waybar &
```

**Change Colors:**
Edit **style.css**:
```css
window {
  background-color: #1e1e1e;
  color: #ffffff;
}
```

**Configure Time Format:**
```json
"clock": {
  "format": "{:%H:%M %a}",
  "tooltip-format": "{:%Y-%m-%d}"
}
```

---

### Rofi

Application launcher and window switcher with Nord theme, using RASI configuration format.

#### Architecture

Rofi configuration uses RASI (Rofi Advanced Style and Input) format:
- **config.rasi** - Main configuration (behavior, keybindings, layout)
- **theme.rasi** - Styling and colors

#### Configuration Sections

```rasi
configuration {
  modi = "drun,run,window";           // Available modes
  show-icons = true;                  // Display application icons
  drun-display-format = "{name}";     // Format shown for apps
  display-drun = "Apps";              // Label for drun mode
  terminal = "ghostty";               // Terminal for `run` mode
  timeout { action = "kb-cancel"; }   // Auto-close after timeout
}
```

#### Available Modes

- **drun** - Desktop application launcher (reads .desktop files)
- **run** - Execute arbitrary commands in shell
- **window** - Switch between open windows
- **filebrowser** - File selection mode

Multiple modes can be active; user switches between them via keybindings.

#### Theming (theme.rasi)

Defines:
- Color palette (background, foreground, accent, error)
- Font family and sizes
- Window styling (borders, shadows, corners)
- Element styling (buttons, input field, list items)

Nord theme applied via color definitions:
```rasi
* {
  background-color: #2e3440;
  foreground-color: #eceff4;
  accent-color: #88c0d0;
  error-color: #bf616a;
}
```

#### Keybindings

Rofi includes default keybindings; customize in config:
```rasi
configuration {
  kb-select-1 = "Alt+1";
  kb-select-2 = "Alt+2";
  kb-mode-next = "Alt+Tab";           // Switch between modes
  kb-mode-previous = "Alt+Shift+Tab";
  kb-cancel = "Escape";
}
```

#### Icon Configuration

Icons sourced from:
- System icon theme (configured at OS level)
- .desktop file Icon field
- Fallback to generic icons

Enable with `show-icons = true`.

#### Wallpaper Background Integration

Rofi can display current wallpaper as background:
- Theme sets background-image property
- Fetches from hyprpaper or system background
- Transparency layer over background

#### Window Mode

Switches to window list with configured mode-switch key:
- Shows open windows across all workspaces
- Select to focus/raise window
- Can be configured to switch workspaces too

#### Comparison with Quickshell Launcher

| Aspect | Rofi | Quickshell |
|--------|------|-----------|
| Configuration | RASI (CSS-like) | QML |
| Launcher search | Fuzzy (built-in) | Custom QML algorithm |
| Additional features | Window switcher, run mode | Integrated with bar, wallpaper |
| Learning curve | Low (familiar CSS) | Higher (QML) |
| Theming | RASI + theme files | QML styling |
| Dependency | Standalone | Part of Quickshell |

#### Common Rofi Tasks

**Customize Colors:**
Edit **theme.rasi**:
```rasi
* {
  background-color: #2e3440;
  foreground-color: #eceff4;
  accent-color: #88c0d0;
}
```

**Change Font:**
```rasi
* {
  font: "Sarasa Gothic Nerd Font 12";
}
```

**Enable Window Switcher:**
```rasi
configuration {
  modi = "drun,run,window";
  display-window = "Windows";
}
```

**Filter Applications:**
Edit `.desktop` files to add `NoDisplay=true` to exclude from launcher.

**Change Layout/Positioning:**
```rasi
window {
  width: 50%;
  height: 50%;
  location: center;
}
```

**Set Timeout for Auto-Close:**
```rasi
configuration {
  timeout {
    action = "kb-cancel";
    delay = 3000;  // milliseconds
  }
}
```

**Test Configuration:**
```bash
rofi -config ~/.config/rofi/config.rasi -show drun
```

---

## Terminal Emulators

### Ghostty (Primary)

Modern terminal emulator with Nord custom theme, integrated into Hyprland as primary terminal.

#### Configuration

**config** - Single configuration file using key-value format:
- **theme** - Visual theme reference (custom Nord variant)
- **font** - Font family and rendering options
- **cursor** - Cursor style and appearance
- **window** - Transparency and visual settings

#### Custom Theme

**themes/nord-custom** - Nord color palette with custom adjustments:
- Dark background (#2e3440)
- Light foreground (#d8dee9)
- Accent colors for UI elements
- Optimized contrast for readability

#### Key Settings

**Font Configuration:**
```
font-family = Sarasa Gothic Nerd Font
font-size = 12
font-feature = -liga  # Disable ligatures if needed
```

**Transparency:**
```
window-padding-x = 8
window-padding-y = 8
background-opacity = 0.9
```

**Cursor Appearance:**
```
cursor-style = block  # or beam, underline
cursor-opacity = 0.5
```

#### Integration

- **Hyprland** - Primary terminal (SUPER+RETURN)
- **Yazi** - File manager launched in floating window (SUPER+E)
- **Niri** - Preferred terminal environment variable

#### Common Ghostty Tasks

**Change Font Size:**
```
font-size = 14
```

**Adjust Opacity:**
```
background-opacity = 0.95
```

**Change Cursor Style:**
```
cursor-style = beam  # or block, underline
```

**Enable Ligatures:**
```
font-feature = +liga
```

**Reload Configuration:**
Ghostty watches config file and reloads automatically on changes.

---

### Alacritty

GPU-accelerated terminal emulator with Nord theme and font customization.

#### Configuration

**alacritty.toml** - Single TOML configuration file:
- **colors** - Nord color palette for foreground/background/UI elements
- **font** - Typeface, size, and style settings
- **window** - Opacity, padding, dimensions
- **behavior** - Scrollback, copy-on-select, bell settings

#### Colors

Nord theme applied via color definitions:
```toml
[colors.primary]
background = "#2e3440"
foreground = "#d8dee9"

[colors.cursor]
text = "#2e3440"
cursor = "#d8dee9"
```

#### Font Configuration

Sarasa Gothic Nerd Font used by default:
```toml
[font]
family = "Sarasa Gothic Nerd Font"
style = "Regular"
size = 12
```

Fallback fonts specified as list for missing glyphs.

#### Window Opacity

```toml
[window]
opacity = 0.9  # 1.0 = fully opaque, 0.0 = fully transparent
padding = { x = 8, y = 8 }
```

#### Copy on Select

Automatic clipboard copy on text selection:
```toml
[selection]
save_to_clipboard = true
```

#### Common Alacritty Tasks

**Change Font Size:**
```toml
[font]
size = 14
```

**Modify Opacity:**
```toml
[window]
opacity = 0.95  # Between 0-1
```

**Enable/Disable Copy on Select:**
```toml
[selection]
save_to_clipboard = true  # or false
```

**Customize Cursor:**
```toml
[cursor]
style = "Beam"  # Block, Underline, or Beam
```

**Reload Configuration:**
Alacritty watches configuration file for changes and reloads automatically.

---

### Kitty

Terminal emulator with Nord theme and advanced features like image rendering and ligature support.

#### Configuration

**kitty.conf** - Single configuration file using key-value format:
- **colors** - Nord color palette
- **font** - Font family, size, and rendering options
- **window** - Transparency, padding, opacity
- **advanced** - Image support, ligatures, dynamic opacity

#### Color Scheme

Nord theme applied inline:
```
foreground #d8dee9
background #2e3440
color0 #3b4252
color1 #bf616a
```

#### Font Configuration

Sarasa Gothic Nerd Font:
```
font_family      Sarasa Gothic Nerd Font
font_size        12
disable_ligatures never  # Enable ligatures for better appearance
```

#### Window Transparency

```
background_opacity 0.9
dynamic_background_opacity yes  # Change opacity with keybind
```

#### Image Protocol

Kitty uses own image protocol for displaying images:
```
enabled_layouts tall:bias=50,stack
```

#### Integration

- **Tmux** - Full support for Kitty image protocol in panes
- **Pager integration** - Images display in less/more with proper protocol support

#### Common Kitty Tasks

**Change Font Size:**
```
font_size 14
```

**Adjust Opacity:**
```
background_opacity 0.95
```

**Enable/Disable Ligatures:**
```
disable_ligatures never    # Enable ligatures
disable_ligatures always   # Disable ligatures
```

**Set Window Padding:**
```
window_padding_width 8
```

**Configure Layout:**
```
enabled_layouts tall,stack,grid
```

**Change Cursor Shape:**
```
cursor_shape beam  # or block, underline
cursor_blink_interval 0  # 0 to disable blinking
```

**Create Custom Keybindings:**
```
map ctrl+alt+t new_tab_with_cwd
map ctrl+alt+n new_os_window
```

**Enable Dynamic Opacity:**
```
dynamic_background_opacity yes
map ctrl+shift+> increase_background_opacity
map ctrl+shift+< decrease_background_opacity
```

**Test Image Protocol:**
```bash
kitty +icat image.png
```

**Reload Configuration:**
Kitty watches config file and reloads automatically on changes.

---

## Editor

### Neovim

LazyVim-based Neovim configuration with modular plugin management, custom keybindings, and cross-platform support.

#### Architecture

Uses **LazyVim** as the base framework with modular plugin specifications:
- **init.lua** - Entry point, requires config.lazy which sets up the plugin system
- **lua/config/lazy.lua** - Bootstrap LazyVim and configure lazy.nvim plugin manager
- **lua/config/keymaps.lua** - Custom keybindings and keymap overrides
- **lua/config/autocmds.lua** - Autocommands for various file types and events
- **lua/config/options.lua** - Nvim options (tabs, indent, search behavior, etc.)
- **lua/plugins/** - Plugin specifications organized by category
  - colorscheme.lua - Color scheme plugins
  - coding.lua - Completion, snippets, LSP-related plugins
  - editor.lua - Editor behavior, syntax, movement plugins
  - integration.lua - External service integrations

#### Plugin System (lazy.nvim)

LazyVim uses **lazy.nvim** for lazy-loading plugins:
- Plugins are specified as tables with `{repo, opts, config, ...}`
- `lazy = true` for lazy-loaded plugins (lazy.nvim determines when to load)
- `lazy = false` for plugins loaded on startup
- `dev = true` uses local filesystem path instead of installing from repo
- `build` runs post-install commands (e.g., treesitter `:TSUpdate`)

#### Version Pinning

**lazy-lock.json** stores exact git commit hashes for reproducible builds:
- Auto-generated after `Lazy` sync/update
- Commit to version control for consistent environments
- Pin specific plugin versions by editing manually (advanced)

#### Plugin Organization

Each category file returns a list of plugin specs:

```lua
-- lua/plugins/editor.lua
return {
  { "plugin-author/plugin-name", opt1 = val1, config = function(plugin, opts) ... end },
  ...
}
```

- **colorscheme.lua** - Only one colorscheme should set `priority = 1000`
- **coding.lua** - LSP servers, completion engines, snippet engines
- **editor.lua** - Treesitter, folding, fuzzy finding
- **integration.lua** - Git, terminal, debugging, external tools

#### Configuration Locations

- **keymaps.lua** - Use `vim.keymap.set(mode, lhs, rhs, opts)` pattern
- **autocmds.lua** - Use `vim.api.nvim_create_autocmd(event, {pattern, callback})`
- **options.lua** - Set via `vim.opt.option_name = value`

#### LazyVim Overrides

LazyVim provides sensible defaults. To customize:
- Use `opts` table to merge with defaults
- Use `config` function to run custom code after plugin loads
- Use `keys` to customize keybindings per plugin

#### Windows/Powershell Compatibility

Some plugins have cross-platform concerns:
- Path separators: Use forward slashes (Nvim normalizes on Windows)
- Shell commands: Wrap in `vim.fn.has("win32")` checks if needed
- Check lazyvim.json for any Windows-specific overrides

#### Plugin Dependencies

Some plugins depend on others:
- **LSP setup** - Requires mason.nvim for language server management
- **Completion** - Requires nvim-cmp and snippet engine (luasnip or vim-vsnip)
- **Treesitter** - Some plugins use tree-sitter for better highlighting/parsing

Lazy.nvim handles dependency ordering automatically.

#### Performance Considerations

- Use `lazy = true` for plugins you don't need on every startup
- Startup plugins should be in separate files to keep load-time down
- `IncCommand` preview can be slow for large files; may need buffer-size limits

#### Integration Points

- **Shell** - Inherits terminal from $EDITOR or uses neovim terminal `:terminal`
- **Git integration** - Plugins use git CLI for diff, blame, log operations
- **LSP servers** - Managed via mason.nvim, installed to `~/.local/share/nvim/mason/`
- **Ripgrep** - Used by telescope.nvim for fast file searching
- **Node.js/Python** - Some LSPs require these (e.g., node for efm-langserver)

#### Common Neovim Tasks

**Add a New Plugin:**
1. Create or edit plugin file in `lua/plugins/` (e.g., new-feature.lua)
2. Add plugin spec to table:
```lua
return {
  { "author/repo", lazy = true, event = "FileType lua", opts = {}, config = function(plugin, opts)
    -- setup code
  end }
}
```
3. Run `:Lazy sync` to install and lock version

**Update All Plugins:**
```vim
:Lazy update
```

**Override LazyVim Default Plugin:**
Edit the plugin spec in `lua/plugins/` and set `enabled = false` for defaults, or add custom version with same name to override.

**Debug Plugin Loading:**
```vim
:Lazy profile      " Show startup time breakdown
:Lazy log          " View plugin load events
```

**Add Custom Keybinding:**
Edit `lua/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<Leader>key", ":command<CR>", { noremap = true, silent = true })
```

**Configure LSP for New Language:**
1. Install language server via Mason: `:Mason` → search language
2. Update lspconfig setup in coding.lua if needed
3. Add formatter config if desired

**Manage Treesitter Languages:**
```vim
:TSInstall language-name      " Install parser
:TSUpdate                     " Update all installed parsers
:TSUninstall language-name    " Remove parser
```

---

## Utilities

### Dunst

Notification daemon with Nord theme, custom rules for specific applications, and keyboard controls.

#### Configuration

**dunstrc** - Single configuration file with INI-like format:
- **[global]** - Global notification settings
- **[urgency_low/normal/critical]** - Appearance rules by urgency level
- **[app-name]** - Application-specific rules

#### Global Settings

```ini
[global]
monitor = 0                    # Monitor number for notification placement
follow = mouse                 # Follow mouse when active
geometry = "300x5-10+10"      # Width x height x offset-x+offset-y
frame_color = "#88c0d0"       # Nord accent color
background = "#2e3440"        # Nord background
foreground = "#d8dee9"        # Nord foreground
```

#### Urgency Levels

Notifications can be low, normal, or critical urgency:
- **low** - Informational messages, dimmer appearance
- **normal** - Standard notifications, default styling
- **critical** - Errors, high visibility, longer timeout

Each level has separate color and display settings.

#### Appearance

Nord-themed styling:
```ini
[global]
font = Sarasa Gothic Nerd Font 10
corner_radius = 8
border_width = 2
padding = 12
frame_width = 2
```

#### Keyboard Controls

Dunst supports keyboard shortcuts for notification management:
```ini
[global]
close = mod4+x              # Close notification
close_all = mod4+shift+x    # Close all notifications
context = mod4+period       # Open URL in notification
```

#### Application-Specific Rules

Custom rules can target specific apps:
```ini
[flameshot]
background = "#a3be8c"
foreground = "#2e3440"
timeout = 5

[slack]
format = "<b>%s</b>\n%b"
```

Rules match by `appname` and can override global settings.

#### Integration

- **Hyprland** - System notifications from WM events
- **Terminal applications** - Notifications from shell, build tools, etc.
- **Flameshot** - Custom notification styling for screenshot confirmations
- **System services** - Battery, network, volume change alerts

#### Common Dunst Tasks

**Change Notification Position:**
```ini
[global]
geometry = "300x5-10+10"    # x-offset+y-offset (top-right)
gravity = "top-right"       # Or top-center, bottom-left, etc.
```

**Set Notification Timeout:**
```ini
[global]
timeout = 5  # seconds
```

**Add Application-Specific Rule:**
```ini
[custom-app-name]
format = "<b>%s</b>\n%b"
background = "#bf616a"
timeout = 8
```

**Enable/Disable Notifications from App:**
```ini
[noisy-app]
format = ""  # Empty format hides notification
```

**Configure Keyboard Shortcuts:**
```ini
[global]
close = ctrl+shift+n
history = ctrl+grave
context = ctrl+period
```

**Round Corners:**
```ini
[global]
corner_radius = 12
border_width = 2
```

**Reload Dunst Configuration:**
```bash
killall dunst && dunst &
```

**Test Notification:**
```bash
notify-send "Test Title" "Test body"
notify-send -u critical "Critical" "This is urgent"
```

---

### Wlogout

Logout menu with action buttons for lock, logout, reboot, and shutdown. Configurable layout and styling.

#### Configuration

Wlogout uses modular configuration:
- **layout** - Button layout and action definitions
- **style.css** - Visual styling and appearance
- **icons/** - Button icons (PNG images for each action)

#### Layout File

Defines button grid and associated commands:
```json
{
  "label": "logout",
  "action": "hyprctl dispatch exit",
  "text": "Logout",
  "keybind": "e"
}
```

#### Available Actions

- **hyprctl dispatch exit** - Exit Hyprland
- **systemctl poweroff** - Shutdown system
- **systemctl reboot** - Reboot system
- **hyprlock** - Lock screen (with hyprlock integration)
- **systemctl suspend** - Suspend/sleep
- **loginctl terminate-session %i** - Terminate session

#### Icons

**icons/** directory contains PNG images for each button:
- **logout.png** - Logout button icon
- **shutdown.png** - Power off icon
- **reboot.png** - Restart icon
- **lock.png** - Lock screen icon
- **suspend.png** - Sleep/suspend icon
- **hibernate.png** - Hibernation icon

#### Style

**style.css** controls appearance:
```css
* {
  font-family: Sarasa Gothic Nerd Font;
  background-color: #2e3440;
}

window {
  background-color: rgba(46, 52, 64, 0.9);
}

button:hover {
  background-color: #434c5e;
}
```

Nord theme applied throughout.

#### Integration

- **Hyprland** - Launched via keybind for system shutdown/logout
- **System services** - Uses systemctl for power management

#### Common Wlogout Tasks

**Change Button Actions:**
Edit **layout** file:
```json
"action": "systemctl poweroff"
```

**Add New Button:**
```json
{
  "label": "suspend",
  "action": "systemctl suspend",
  "text": "Sleep",
  "keybind": "s"
}
```

**Customize Colors:**
Edit **style.css**:
```css
window {
  background-color: rgba(46, 52, 64, 0.95);
}

button {
  background-color: #3b4252;
  color: #d8dee9;
}

button:hover {
  background-color: #434c5e;
}
```

**Set Icon Size:**
```css
button image {
  min-width: 48px;
  min-height: 48px;
}
```

**Modify Icon Opacity:**
```css
button image {
  opacity: 0.8;
}

button:hover image {
  opacity: 1.0;
}
```

**Test Logout Menu:**
```bash
wlogout
# Or with specific layout
wlogout -l ~/.config/wlogout/layout
```

---

### Yazi

File manager configuration with Lua plugin system, custom keybindings, and Hyprland integration.

#### Architecture

Yazi uses a Lua-based configuration system:
- **yazi.toml** - Core configuration (general settings, layout, behavior)
- **keymap.toml** - Keyboard shortcuts and command bindings
- **theme.toml** - Color scheme and visual appearance
- **init.lua** - Lua initialization code for advanced customization
- **plugins/** - Community plugins with Lua implementations
- **flavors/** - Color scheme variants (e.g., nord.yazi/)

#### Plugin System

Plugins are Lua modules in the `plugins/` directory:
- Each plugin has a `main.lua` file with `setup()` and hooks
- Plugins can handle keybindings, previews, event hooks
- Plugins integrate via `prepend_keymap` to add or override keybindings

#### Keymap Organization

**keymap.toml** structure:
```toml
[[input.prepend_keymap]]
on = "key"
run = "command"
desc = "Description"

[[mgr.prepend_keymap]]
on = ["key1", "key2"]
for = "platform"  # linux, macos, windows
run = 'command or "plugin plugin-name"'
```

Uses `prepend_keymap` for keybinding layers that override defaults.

#### Included Plugins

- **full-border.qml** - Adds decorative borders around pane windows
- **git.yazi** - Git status integration (shows modified, staged, ignored files)
- **smart-enter.yazi** - Context-aware file/directory opening
- **smart-tab.yazi** - Tab creation with smart navigation

#### Color Scheme Management

**flavors/nord.yazi/** - Nord theme variant:
- `flavor.toml` - Color definitions
- `tmtheme.xml` - Original theme source

**theme.toml** - Active theme settings:
- References flavor colors
- Defines UI element colors (background, foreground, selection)
- Customizes file type specific colors

#### File Manager Behavior

Key behavior settings in **yazi.toml**:
- **scrolloff** - Keep N lines visible above/below cursor
- **show_hidden** - Display hidden files
- **sort_by** - Sort order (name, modified, size)
- **sort_dir_first** - Place directories before files
- **linemode** - Display style (none, size, mtime, permissions)

#### Custom Keybindings

Keybindings use command syntax:
```toml
[[mgr.prepend_keymap]]
on = "l"
run = "plugin smart-enter"
desc = "Enter directory or open file"
```

Commands can be:
- Built-in Yazi commands (enter, leave, reveal, etc.)
- Plugin invocations: `plugin plugin-name`
- Shell commands: `shell command args`
- Custom scripts with shell fallback

#### Wallpaper Integration

Custom keybinding for Hyprland integration:
```toml
[[mgr.prepend_keymap]]
on = ["<Space>", "w"]
for = "linux"
run = 'shell -- hyprctl hyprpaper reload ,"$0"'
desc = "Set hovered file as wallpaper"
```

Uses `hyprctl hyprpaper reload` with file path to set wallpaper.

#### Cross-Platform Considerations

Keybindings can be platform-specific:
```toml
for = "linux"    # Only on Linux
for = "macos"    # Only on macOS
for = "windows"  # Only on Windows
for = "unix"     # Unix-like (Linux, macOS)
```

#### Opener Configuration

Yazi uses file associations to determine how to open files:
- Configure in yazi.toml `[opener]` section
- Can specify different openers for different file types
- Fallback to default application if no match

#### Integration Points

- **Hyprland** - Wallpaper setting via hyprctl, launcher integration
- **Terminal emulator** - Launches file browser in ghostty or kitty
- **Git** - Status display via git.yazi plugin
- **Shell** - Executes shell commands for file operations

#### Common Yazi Tasks

**Add a Custom Keybinding:**
Edit **keymap.toml**:
```toml
[[mgr.prepend_keymap]]
on = "g"
run = "cd /home"
desc = "Go to home"
```

**Enable a Plugin:**
1. Ensure plugin directory exists in `~/.config/yazi/plugins/plugin-name/`
2. Add keybinding in keymap.toml: `run = "plugin plugin-name"`

**Customize Colors:**
Edit **theme.toml** or **flavors/nord.yazi/flavor.toml**:
```toml
[colors]
fg = "#d8dee9"
bg = "#2e3440"
black = "#3b4252"
```

**Set Default Sort Order:**
```toml
sort_by = "modified"
sort_reverse = true
sort_dir_first = true
```

**Filter Files:**
Use `/` to search or create custom filter keybindings in keymap.toml.

**Create Symbolic Link:**
```toml
[[mgr.prepend_keymap]]
on = ["l", "n"]
run = "shell ln -s \"$0\" ."
desc = "Create symlink"
```

---

## Theme & Appearance

### Nord Color Palette

All components use the Nord color palette for consistency. The complete palette:

```
nord0:  #2e3440  - Darkest (background)
nord1:  #3b4252  - Dark backgrounds
nord2:  #434c5e  - Dark UI elements
nord3:  #4c566a  - Dark borders/shadows

nord4:  #d8dee9  - Light text
nord5:  #e5e9f0  - Light backgrounds
nord6:  #eceff4  - Lightest text

nord7:  #8fbcbb  - Frost cyan
nord8:  #88c0d0  - Frost blue (primary accent)
nord9:  #81a1c1  - Frost darker blue
nord10: #5e81ac  - Frost darkest blue

nord11: #bf616a  - Aurora red (errors)
nord12: #d08770  - Aurora orange (warnings)
nord13: #a3be8c  - Aurora green (success)
nord14: #b48ead  - Aurora magenta
nord15: #a3be8c  - Aurora green (alternative)
```

### Font Configuration

**Sarasa Gothic Nerd Font** is used throughout the configuration:
- Install via `aur/ttf-sarasa-gothic-nerd-fonts` or manually
- Provides excellent monospace rendering with ligature support
- Includes Nerd Font icons for UI elements and terminal display
- Default size varies by component:
  - Terminals: 12-14pt
  - UI elements (dunst, rofi): 10-12pt
  - Bars/panels: varies per widget

### Opacity & Transparency Settings

- **Terminal backgrounds:** 0.9 (slight transparency for desktop view)
- **Notification windows:** 0.9 (consistent with terminals)
- **Logout menu:** 0.9 (darkened overlay effect)
- **Window manager decorations:** No transparency (full opaque borders)

---

## Cross-Package Integration

### Hyprland as Central Hub

Hyprland is the central integration point for most applications:

**Keybindings trigger associated apps:**
- `SUPER+RETURN` → Opens Ghostty terminal
- `SUPER+SPACE` → Opens Rofi launcher (or Quickshell via alternate bind)
- `SUPER+E` → Opens Yazi file manager in floating window
- `SUPER+P` → Opens password manager or custom app
- `SUPER+W` → Reloads wallpaper/Hyprpaper

**Environment variables inherited by all child processes:**
- `TERMINAL=ghostty` - Used by system tools to launch terminal
- `EDITOR=nvim` - Used by git, systemctl, etc. for editing
- `XDG_CURRENT_DESKTOP=Hyprland` - Allows apps to detect WM

### Shell → Terminal → WM Relationships

1. **Zsh configuration** (zsh/.zshrc):
   - Sets up Starship prompt which adapts based on terminal width
   - Initializes ASDF for version management
   - Loads Zinit plugins for extended functionality

2. **Starship prompt** (starship.toml / starship_short.toml):
   - Receives COLUMNS from terminal emulator
   - Displays git info, language versions, status
   - Nord colors for consistency

3. **Terminal emulators** (Ghostty, Alacritty, Kitty):
   - Set Nord color palette
   - Report correct COLUMNS for shell
   - Inherit shell configuration from environment

4. **Hyprland keybindings:**
   - Launch terminals which load zsh
   - zsh loads Starship prompt
   - Terminal renders with inherited font/color settings

### Theme Consistency Across Components

Nord palette applied across all components:
- **Hyprland:** Border colors, notification colors
- **Quickshell/Waybar:** Background and text colors
- **Terminals:** Foreground/background, cursor colors
- **Editor (Neovim):** Colorscheme plugin for consistency
- **Notifications (Dunst):** Background, foreground, frame colors
- **File manager (Yazi):** Theme files and color definitions
- **All other utilities:** Custom Nord color specifications

### Script Dependencies

Several packages have helper scripts that integrate with others:

**Hyprland scripts:**
- `reload-quickshell.sh` - Restart Quickshell panel from Hyprland keybind
- `reload-waybar.sh` - Restart Waybar status bar
- `reload-hyprpaper.sh` - Reload wallpaper daemon
- Called from hyprland/conf/binds.conf

**Quickshell scripts:**
- `quickshell-program-list.sh` - Generate app list for launcher
- Scans system and Flatpak applications
- Called on Quickshell startup

**Tmux scripts:**
- `tmux-uptime.sh` - Display system uptime in status bar
- `tmux-loadavg.sh` - Display load average with color coding
- Called periodically in status bar updates

**Waybar scripts:**
- `waybar-calendar.sh` - Display calendar information
- `waybar-custom.sh` - Custom status updates
- Called with intervals defined in config.jsonc

---

## Development Workflow

### Applying/Removing Configuration

```bash
# Apply a single package
stow package-name

# Apply multiple packages at once
stow zsh tmux neovim starship

# Remove a package
stow -D package-name

# Check what would be symlinked (dry-run)
stow -n package-name

# Check for conflicts before stowing
stow --simulate package-name

# Verify symlinks after stowing
ls -la ~/
ls -la ~/.config/
```

### Testing Configuration Changes

**Reload by component:**

```bash
# Hyprland: Use keybind or command
hyprctl reload

# Quickshell: Restart service
systemctl --user restart quickshell
# or
killall quickshell && quickshell &

# Waybar: Kill and restart
killall waybar && waybar &

# Tmux: Inside tmux session
:source-file ~/.tmux.conf
# or from shell
tmux source-file ~/.tmux.conf

# Zsh: Source directly or start new shell
source ~/.zshrc
# or start new terminal

# Neovim: Changes apply on next editor start
# Some plugins may require :Lazy sync and restart

# Ghostty/Alacritty/Kitty: Watch and auto-reload on config change
# No action needed in most cases
```

### Package-Specific Testing Tips

**Hyprland:**
- Use `hyprctl` to query current state without reloading
- `hyprctl monitors all` - Check monitor configuration
- `hyprctl clients` - List windows and their properties
- `hyprctl workspaces` - Check workspace configuration

**Quickshell:**
- Test program list script: `~/.scripts/quickshell-program-list.sh | jq .`
- Check for JSON syntax errors

**Tmux:**
- Test status scripts: `~/.scripts/tmux-uptime.sh`
- Reload within session: `C-a :source-file ~/.tmux.conf`

**Zsh:**
- Debug plugin loading: `ZINIT[VERBOSE]=1 source ~/.zshrc`
- Check plugin installation: `ls ~/.local/share/zinit/zinit.git/plugins/`

**Neovim:**
- Check plugin status: `:Lazy` to open Lazy.nvim UI
- Profile startup: `:Lazy profile` to see plugin load times
- Check health: `:checkhealth` for dependency issues

---

## Common Workflows

### Setting Up a New Machine

1. **Clone dotfiles:**
   ```bash
   git clone <repo> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Install essential packages** (using your package manager):
   ```bash
   # Arch/Manjaro example
   pacman -S zsh tmux neovim ghostty
   pacman -S hyprland quickshell rofi dunst
   pacman -S noto-fonts-cjk noto-fonts-emoji
   yay -S ttf-sarasa-gothic-nerd-fonts
   ```

3. **Stow core packages:**
   ```bash
   stow zsh starship tmux
   source ~/.zshrc  # Reload shell
   ```

4. **Customize for hardware:**
   - Edit `hyprland/.config/hypr/conf/monitor.conf`
   - Edit `hyprland/.config/hypr/conf/environments.conf`
   - Edit `hyprland/.config/hypr/conf/input.conf`

5. **Stow remaining packages:**
   ```bash
   stow hyprland quickshell rofi ghostty dunst wlogout yazi neovim
   ```

6. **Test configuration:**
   - Restart or login to apply changes
   - Verify symlinks: `ls -la ~/.config/`

### Switching Window Managers

**From Hyprland to Niri:**
1. Stow Niri: `stow niri`
2. Unstow Hyprland: `stow -D hyprland`
3. Update Quickshell/Waybar keybindings if needed (currently Hyprland-specific)
4. Logout and select Niri session from display manager

**From Niri to Hyprland:**
1. Stow Hyprland: `stow hyprland`
2. Unstow Niri: `stow -D niri`
3. Logout and select Hyprland session

Note: Quickshell and Waybar are Hyprland-specific due to workspace/window detection. If using Niri, use alternative bars.

### Switching Status Bars

**From Quickshell to Waybar:**
1. Keep Hyprland stowed
2. Quickshell will remain active (not removed)
3. Stow Waybar: `stow waybar`
4. Update Hyprland keybindings to launch Waybar
5. Kill Quickshell: `killall quickshell`

**From Waybar to Quickshell:**
1. Stow Quickshell (already stowed in default setup)
2. Kill Waybar: `killall waybar`
3. Restart Quickshell: `systemctl --user restart quickshell`

### Customizing Colors Globally

To change color scheme across all applications:

1. **Choose new palette** (e.g., Dracula, Gruvbox)

2. **Update files:**
   - `hyprland/.config/hypr/conf/general.conf` - Border colors
   - `hyprland/.config/hypr/conf/decoration.conf` - Decoration colors
   - `starship.toml` and `starship_short.toml` - Module colors
   - `tmux/.tmux.conf` - Status bar colors (or theme plugin)
   - `rofi/theme.rasi` - All color definitions
   - Terminal configs - colors (alacritty.toml, kitty.conf, ghostty/config)
   - `dunst/dunstrc` - Notification colors
   - `yazi/flavors/custom.yazi/flavor.toml` - File manager theme
   - `quickshell/modules/Launcher.qml` - Launcher colors (if customizing)

3. **Reload affected applications:**
   ```bash
   hyprctl reload
   source ~/.zshrc
   tmux source-file ~/.tmux.conf
   killall dunst && dunst &
   ```

### Adding New Keybindings

**To Hyprland:**
Edit `hyprland/.config/hypr/conf/binds.conf`:
```
bind = $mainMod, KEY, action
bindl = , XF86_KEY, action       # For always-listening keys
binde = $mainMod, KEY, action    # For repeatable actions
```

Then reload: `hyprctl reload`

**To Tmux:**
Edit `.tmux.conf`:
```tmux
bind KEY action
```

Then reload in tmux: `C-a :source-file ~/.tmux.conf`

**To Zsh:**
Add to `zsh/.zshrc`:
```zsh
bindkey "key-sequence" action
```

Then reload: `source ~/.zshrc`

**To Neovim:**
Edit `neovim/.config/nvim/lua/config/keymaps.lua`:
```lua
vim.keymap.set("n", "<Leader>key", ":command<CR>", { noremap = true, silent = true })
```

Changes apply on next Neovim start.

---

## Troubleshooting

### Window Manager Won't Start

**Hyprland issues:**
- Check logs: `journalctl -xe | grep -i hyprland`
- Verify GPU drivers: Check if AMD/NVIDIA/Intel drivers installed
- Test configuration: `hyprctl reload` from TTY
- Missing dependencies: Install wayland, libxcb, gcc, etc.

**Niri issues:**
- Check if Niri is installed: `niri --version`
- Verify XDG session support in display manager
- Check KDL syntax in config.kdl (use niri to validate)

### Bar/Panel Issues

**Quickshell not launching:**
- Check service: `systemctl --user status quickshell`
- View logs: `journalctl --user -xe | grep quickshell`
- Verify IPC: `quickshell --socket /run/user/1000/quickshell-0`

**Waybar not appearing:**
- Check logs: `waybar &` (run in foreground to see output)
- Verify config.jsonc JSON syntax
- Ensure modules are correctly configured

**Rofi launcher not responding:**
- Test directly: `rofi -show drun`
- Check theme file exists
- Verify terminal setting: `terminal = "ghostty"`

### Terminal Problems

**Terminal won't open from Hyprland:**
- Check SUPER+RETURN keybinding is correct
- Verify terminal executable exists: `which ghostty`
- Check Hyprland logs: `hyprctl -i <window_id>`

**Font rendering issues:**
- Verify Sarasa Gothic is installed: `fc-list | grep Sarasa`
- Check font name in config matches system
- Restart terminal after font installation

**Transparency not working:**
- Check compositor support: Hyprland has built-in support
- Verify opacity setting syntax in terminal config
- Some WMs may not support opacity well

### Shell/Prompt Issues

**Starship prompt not switching configs:**
- Check `COLUMNS` is set: `echo $COLUMNS`
- Verify config files exist: `ls ~/.config/starship*.toml`
- Check `set_starship_config_precmd` function in .zshrc

**Zinit plugins not loading:**
- Debug mode: `ZINIT[VERBOSE]=1 source ~/.zshrc`
- Check plugin repo URLs are accessible
- Verify `~/.local/share/zinit/` directory exists

**History not working:**
- Check HISTSIZE/SAVEHIST settings in zsh/.zshrc
- Verify history file permissions: `ls -la ~/.zsh_history`
- Clear history if corrupted: `rm ~/.zsh_history`

**ASDF version switching not working:**
- Check `.tool-versions` file format (one tool per line)
- Verify language is installed: `asdf list nodejs`
- Check PATH order: `echo $PATH | tr ':' '\n' | head -n 5`

### Font and Theme Issues

**Icons not displaying:**
- Verify Nerd Font is installed: `fc-list | grep "Nerd Font"`
- Check font configuration in applications
- Some terminals may need font-feature settings adjusted

**Color palette looks wrong:**
- Verify Nord hex codes are correct
- Check if theme is being overridden by system settings
- Test in different terminal to isolate issue

**Text rendering too small/large:**
- Adjust font size in config files
- Check if font scaling is enabled in WM
- Terminal font size may override system settings

---

## Important Notes

- **Monitor and GPU settings**: Before first Hyprland use, customize `hyprland/.config/hypr/conf/monitor.conf` and `environments.conf` for your hardware
- **Fonts**: Configuration uses Sarasa Gothic Nerd Fonts. Install via `aur/ttf-sarasa-gothic-nerd-fonts` or manually
- **Quickshell app launcher**: Uses a script to detect both system and Flatpak applications
- **Modular approach**: Keep related configs in their own packages; avoid cross-package dependencies where possible
- **.stow-local-ignore files**: Prevent CLAUDE.md files from being symlinked into home directory
- **Backup before changes**: For critical configs, create backups before major modifications
- **Test in isolation**: When troubleshooting, test individual components before blaming integration

---

## File Path Reference

**Commonly Modified Directories:**
- `hyprland/.config/hypr/conf/` - Modular Hyprland configuration files
- `quickshell/.config/quickshell/` - QML modules for bar and launcher
- `zsh/.zshrc` - Main shell configuration
- `neovim/.config/nvim/` - LazyVim configuration with init.lua and lua/config modules
- `tmux/.tmux.conf` - Terminal multiplexer configuration
- `starship/` - Starship prompt configurations (starship.toml, starship_short.toml)
- `rofi/.config/rofi/` - Rofi launcher configuration
- `dunst/.config/dunst/dunstrc` - Notification daemon configuration
- `wlogout/.config/wlogout/` - Logout menu configuration
- `yazi/.config/yazi/` - File manager configuration with keymap and theme

---

**This documentation is comprehensive and serves as the single authoritative source for Claude Code when working with this dotfiles repository. For issues, refer to the relevant section above or use search functionality (Ctrl+F) to find specific topics.**
