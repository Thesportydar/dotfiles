#!/bin/bash

set -e

HOME_DIR="$HOME"
DOTFILES_DIR="$HOME_DIR/dotfiles"

FILES=(
  "bash/.bashrc:$HOME_DIR/.bashrc"
  "bash/.bash_aliases:$HOME_DIR/.bash_aliases"
  "bash/.gh_copilot_alias:$HOME_DIR/.gh_copilot_alias"
  "kitty/kitty.conf:$HOME_DIR/.config/kitty/kitty.conf"
  "kitty/GruvBox_DarkHard.conf:$HOME_DIR/.config/kitty/GruvBox_DarkHard.conf"
  "kitty/TokyoNight.conf:$HOME_DIR/.config/kitty/TokyoNight.conf"
  "neofetch/config.conf:$HOME_DIR/.config/neofetch/config.conf"
  "nvim:$HOME_DIR/.config/nvim"
  "starship/starship.toml:$HOME_DIR/.config/starship.toml"
  "tmux/.tmux.conf:$HOME_DIR/.tmux.conf"
)

echo "Creating symlinks..."

for pair in "${FILES[@]}"; do
  src="${pair%%:*}"
  dest="${pair##*:}"
  full_src="$DOTFILES_DIR/$src"

  echo "Linking $full_src → $dest"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$full_src" "$dest"
done

echo "Done!"
