# dotfiles

Fedora + Hyprland setup.

| Path | What |
| --- | --- |
| `config/alacritty` | terminal |
| `config/cava` | audio visualizer (+ shaders) |
| `config/fastfetch` | system info |
| `config/hypr` | Hyprland + hyprlock |
| `config/nvim` | LazyVim, `ember-muted` colorscheme |
| `config/waybar` | status bar |
| `config/wofi` | launcher |
| `config/gtk-4.0` | GTK4 css |
| `config/spicetify` | Spotify config + `punk` color scheme for Dribbblish |
| `home/` | `.zshrc`, `.bashrc`, `.bash_profile` |
| `scripts/gdm-bg.sh` | set the GDM login background (`sudo`) |

## Install

```sh
git clone <repo> ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks everything into `~` and `~/.config`. Existing files are
moved to `*.pre-dotfiles`, not deleted. Safe to re-run.

## Not included

- Wallpaper: hyprland/hyprlock expect `~/Pictures/wallpapers/979.jpg`
- Spicetify Dribbblish theme itself (install via spicetify marketplace), only `color.ini` is tracked
- zsh plugins: `sudo dnf install zsh-autosuggestions zsh-syntax-highlighting`
