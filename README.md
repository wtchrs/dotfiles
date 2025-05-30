# Dotfiles

## Package lists

- [zsh][zsh]
- [starship][starship] - cross-shell prompt
- [neovim][neovim] - vim-like terminal editor
- [tmux][tmux] - terminal multiplexer
- [hyprland][hyprland] - dynamic tiling wm and compositor for wayland
- [waybar][waybar] - GTK status bar for wayland
- [wlogout][wlogout] - wayland-based logout menu
- [rofi][rofi] - application launcher
- [dunst][dunst] - lightweight and customizable notification daemon
- [alacritty][alacritty] - cross-platform OpenGL terminal emulator

## Getting started

```sh
pacman -S stow
git clone https://github.com/wtchrs/dotfiles
cd dotfiles
```

### Apply packages (Stowing)

```sh
stow zsh
stow starship
stow neovim
stow tmux
stow hyprland
stow waybar
stow wlogout
stow rofi
stow dunst
stow alacritty
```

### Remove packages (Unstowing)

```sh
stow -D package_name
```

## Credits

Configuration inspired by [mylinuxforwork/hyprland-starter][hyprland-starter] and [HyDE-Project/HyDE][HyDE].


[zsh]: https://github.com/zsh-users/zsh
[starship]: https://github.com/starship/starship
[neovim]: https://github.com/neovim/neovim
[tmux]: https://github.com/tmux/tmux
[hyprland]: https://github.com/hyprwm/Hyprland
[waybar]: https://github.com/Alexays/Waybar
[wlogout]: https://github.com/ArtsyMacaw/wlogout
[rofi]: https://github.com/davatorium/rofi
[dunst]: https://github.com/dunst-project/dunst
[alacritty]: https://github.com/alacritty/alacritty
[hyprland-starter]: https://github.com/mylinuxforwork/hyprland-starter
[HyDE]: https://github.com/HyDE-Project/HyDE
