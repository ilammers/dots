#!/usr/bin/env bash
# Symlink dotfiles into place. Safe to re-run.
# Anything already at a target (that isn't our link) is moved to <target>.pre-dotfiles.
set -euo pipefail

DOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CFG=${XDG_CONFIG_HOME:-$HOME/.config}

link() {
  local src=$1 dst=$2
  if [[ -L $dst && $(readlink "$dst") == "$src" ]]; then
    return
  fi
  if [[ -e $dst || -L $dst ]]; then
    mv "$dst" "$dst.pre-dotfiles"
    echo "backed up $dst -> $dst.pre-dotfiles"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked $dst"
}

# whole directories under ~/.config
for d in alacritty cava fastfetch hypr nvim waybar wofi gtk-4.0; do
  link "$DOT/config/$d" "$CFG/$d"
done

# spicetify: only our files, the theme itself is installed separately
link "$DOT/config/spicetify/config-xpui.ini" "$CFG/spicetify/config-xpui.ini"
link "$DOT/config/spicetify/Themes/Dribbblish/color.ini" "$CFG/spicetify/Themes/Dribbblish/color.ini"

# home dotfiles
for f in "$DOT"/home/.[!.]*; do
  link "$f" "$HOME/$(basename "$f")"
done
