# Dotfiles

## Dependencies

- stow - symlink farm manager used for managing dotfiles
- [hyprland][hyprland] - dynamic tiling wm
- [xdg-desktop-portal-hyprland][xdg-desktop-portal-hyprland]
- [hyprpaper][hyprpaper] - wallpaper
- [hyprlock][hyprlock] - lockscreen
- [wlogout][wlogout] - wayland-based logout menu
- [waybar][waybar] - GTK status bar for wayland
- [alacritty][alacritty] - cross-platform OpenGL terminal emulator
- [rofi-wayland][rofi-wayland] - forked version of [rofi][rofi] for wayland support
- [dunst][dunst] - notification daemon
- [thunar][thunar] - file manager
- [Zen Browser][zen-browser] - firefox-based browser
- [zsh][zsh]
- [starship][starship] - cross-shell prompt
- [neovim][neovim] - vim-like terminal editor
- [tmux][tmux] - terminal multiplexer
- [fastfatch][fastfatch] - neofetch like system information tool
- [brightnessctl][brightnessctl]
- [networkmanager][networkmanager]
- [pipewire][pipewire] - audio and video processing engine
- [wireplumber][wireplumber] - manage pipewire
- [mpd-mpris][mpd-mpris] - for displaying now-playing media information on waybar
- qt5-wayland
- qt6-wayland
- ttf-font-awesome
- ttf-fira-sans
- ttf-fira-code
- aur/ttf-sarasa-gothic-nerd-fonts - instead, add only needed one from [here](https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts/releases)

## Stow Package Lists

- zsh
- starship - starship prompt configuration
- neovim - [LazyVim][lazyvim] configuration
- tmux - Nord color theme configuration
- hyprland - hyprland wm configuration
- waybar - status bar configuration
- wlogout - power menu configuration
- rofi - application launcher
- dunst - Notification configuration
- alacritty - Nord color theme with Sarasa Mono Nerd Fonts

## Getting started

### Clone

```sh
git clone https://github.com/wtchrs/dotfiles
cd dotfiles
```

### Apply packages (Stowing)

```sh
stow package_name
```

### Remove packages (Unstowing)

```sh
stow -D package_name
```

## Credits

Configuration inspired by [mylinuxforwork/hyprland-starter][hyprland-starter] and [HyDE-Project/HyDE][HyDE].


[alacritty]: https://github.com/alacritty/alacritty
[brightnessctl]: https://github.com/Hummer12007/brightnessctl
[dunst]: https://github.com/dunst-project/dunst
[fastfatch]: https://github.com/fastfetch-cli/fastfetch
[HyDE]: https://github.com/HyDE-Project/HyDE
[hyprland]: https://github.com/hyprwm/Hyprland
[hyprland-starter]: https://github.com/mylinuxforwork/hyprland-starter
[hyprlock]: https://github.com/hyprwm/hyprlock
[hyprpaper]: https://github.com/hyprwm/hyprpaper
[lazyvim]: https://github.com/LazyVim/LazyVim
[mpd-mpris]: https://github.com/natsukagami/mpd-mpris
[neovim]: https://github.com/neovim/neovim
[networkmanager]: https://networkmanager.dev/
[pipewire]: https://pipewire.org/
[rofi-wayland]: https://github.com/lbonn/rofi
[rofi]: https://github.com/davatorium/rofi
[starship]: https://github.com/starship/starship
[thunar]: https://github.com/neilbrown/thunar
[tmux]: https://github.com/tmux/tmux
[waybar]: https://github.com/Alexays/Waybar
[wireplumber]: https://pipewire.pages.freedesktop.org/wireplumber/
[wlogout]: https://github.com/ArtsyMacaw/wlogout
[xdg-desktop-portal-hyprland]: https://github.com/hyprwm/xdg-desktop-portal-hyprland
[zen-browser]: https://github.com/zen-browser/desktop
[zsh]: https://github.com/zsh-users/zsh
