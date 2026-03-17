# Dotfiles

Personal Arch Linux configuration dotfiles managed with GNU Stow, built around niri and quickshell.

## Screenshot

![screenshot](assets/screenshot.png)

## Requirements

- stow - symlink farm manager for managing dotfiles
- [niri][niri] - scrollable-tiling Wayland compositor
- [quickshell][quickshell] - desktop shell UI (bar, launcher, wallpaper)
- [ghostty][ghostty] - terminal emulator
- [dunst][dunst] - notification daemon
- [swaylock][swaylock] - lock screen
- [nautilus][nautilus] - file manager
- [Zen Browser][zen-browser] - Firefox-based browser
- [zsh][zsh] - shell
- [starship][starship] - cross-shell prompt
- [neovim][neovim] - Vim-based text editor
- [tmux][tmux] - terminal multiplexer
- [brightnessctl][brightnessctl] - brightness control utility
- [networkmanager][networkmanager] - `nmcli` for network widget
- [pipewire][pipewire] - audio and video processing engine
- [wireplumber][wireplumber] - `wpctl` for volume control
- [playerctl][playerctl] - media key controls
- [jq][jq] - used by niri helper script
- qt6-wayland - Qt Wayland platform plugin
- [Symbols Nerd Fonts][nerd-fonts] (ttf-nerd-fonts-symbols) - for Nerd Font icons
- [Sarasa Gothic][sarasa-gothic-font] (ttf-sarasa-gothic) - for Sarasa Mono

### Optional

- [hyprpolkitagent][hyprpolkitagent] - used for polkit prompts, started by the niri config

> [!NOTE]
> I use `niri-wip-git` from the AUR for [blur support](https://github.com/niri-wm/niri/pull/3483). If the feature is merged upstream, you can use the official package instead.

## Stow Packages

- zsh - zsh configuration with zinit plugin manager
- starship - starship prompt configuration
- neovim - [LazyVim][lazyvim] configuration
- tmux - Nord color theme configuration
- dunst - notification configuration
- ghostty - terminal configuration
- niri - niri WM configuration
- quickshell - bar/launcher/wallpaper configuration

## Getting Started

### Clone

```sh
git clone https://github.com/wtchrs/dotfiles.git
cd dotfiles
```

### Apply Stow Packages

Run the following commands from the repository root:

```sh
stow <package>
```

### Remove Stow Packages

Run the following commands from the repository root:

```sh
stow -D <package>
```

### Example Setup

```sh
stow zsh starship neovim tmux dunst ghostty niri quickshell
```

### Niri Configuration

> [!WARNING]
> Before launching niri, review the environment and monitor output settings in:
> - `niri/.config/niri/config.kdl`


[brightnessctl]: https://github.com/Hummer12007/brightnessctl
[dunst]: https://github.com/dunst-project/dunst
[ghostty]: https://github.com/ghostty-org/ghostty
[hyprpolkitagent]: https://github.com/hyprwm/hyprpolkitagent
[jq]: https://github.com/jqlang/jq
[lazyvim]: https://github.com/LazyVim/LazyVim
[nautilus]: https://apps.gnome.org/Nautilus/
[neovim]: https://github.com/neovim/neovim
[nerd-fonts]: https://github.com/ryanoasis/nerd-fonts
[niri]: https://github.com/niri-wm/niri
[networkmanager]: https://networkmanager.dev/
[playerctl]: https://github.com/altdesktop/playerctl
[pipewire]: https://pipewire.org/
[quickshell]: https://quickshell.org/
[sarasa-gothic-font]: https://github.com/be5invis/Sarasa-Gothic
[swaylock]: https://github.com/swaywm/swaylock
[starship]: https://github.com/starship/starship
[tmux]: https://github.com/tmux/tmux
[wireplumber]: https://pipewire.pages.freedesktop.org/wireplumber/
[zen-browser]: https://github.com/zen-browser/desktop
[zsh]: https://github.com/zsh-users/zsh
