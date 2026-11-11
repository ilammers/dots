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

## Tiling modes

``SUPER + ` `` cycles through the modes, ``SUPER + SHIFT + ` `` goes back.
Shown with 4 windows (1 = master / first window).

**1. Centered master** (default, made for the ultrawide; master is 42% wide)

<img src="docs/tiling/centered-master.svg" alt="centered-master layout" width="336">

**2. Master + stack**

<img src="docs/tiling/master-stack.svg" alt="master-stack layout" width="336">

**3. Dwindle (spiral)**

<img src="docs/tiling/dwindle.svg" alt="dwindle layout" width="336">

**4. Scrolling columns** (each column is 1/3 of the screen, the rest scroll off-screen)

<img src="docs/tiling/scrolling.svg" alt="scrolling layout" width="336">

**5. Grid** (2 columns of equal cells; 1 window = full screen, 5+ adds rows)

<img src="docs/tiling/grid.svg" alt="grid layout" width="336">

## Install

```sh
git clone <repo> ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks everything into `~` and `~/.config`. Existing files are
moved to `*.pre-dotfiles`, not deleted. Safe to re-run.

## Not included

- Wallpaper: hyprland/hyprlock expect `~/Pictures/wallpapers/wallpaper.png`
- Spicetify Dribbblish theme itself (install via spicetify marketplace), only `color.ini` is tracked
- zsh plugins: `sudo dnf install zsh-autosuggestions zsh-syntax-highlighting`
