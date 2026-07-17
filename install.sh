#!/usr/bin/env bash
# Bootstrap this NixOS config onto a fresh, already-running NixOS box.
#   curl -sSL https://raw.githubusercontent.com/Iamsofunny/dotfiles/main/install.sh | bash
# Clones to ~/dotfiles (required: hot-reload configs are out-of-store symlinks
# into this exact path), drops in the real hardware config, and rebuilds #laptop.

REPO="https://github.com/Iamsofunny/dotfiles.git"
DIR="$HOME/dotfiles"
HOST="laptop"
# Fresh box hasn't enabled flakes yet; make every nix call (incl. nixos-rebuild) accept them.
export NIX_CONFIG="experimental-features = nix-command flakes"
export REPO DIR HOST

main() {
  set -euo pipefail

  if [ -d "$DIR/.git" ]; then
    echo "==> Updating existing $DIR"
    git -C "$DIR" pull --ff-only
  else
    echo "==> Cloning to $DIR"
    git clone "$REPO" "$DIR"
  fi

  echo "==> Generating hardware config for $HOST"
  sudo nixos-generate-config --show-hardware-config \
    > "$DIR/nix/hosts/$HOST/hardware-configuration.nix"
  # The flake only sees git-tracked files; stage the generated config.
  git -C "$DIR" add "nix/hosts/$HOST/hardware-configuration.nix"

  echo "==> Rebuilding #$HOST"
  sudo nixos-rebuild switch --flake "$DIR/nix#$HOST"

  echo "==> Done. Reboot into the Niri session."
}
export -f main

# Minimal NixOS has no git; borrow one from nix-shell (stable, no flakes needed).
if command -v git >/dev/null 2>&1; then
  main
else
  echo "==> git not found, fetching via nix-shell"
  nix-shell -p git --run main
fi
