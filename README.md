# dotfiles + NixOS flake

Stow-style dotfiles (`<app>/.config/<app>/…`) plus a NixOS flake (in `nix/`)
that builds a Niri Wayland desktop for a single laptop
(`nixosConfigurations.laptop`).

## Layout

- `nix/flake.nix` — inputs: nixos-unstable, home-manager (as NixOS module), niri-flake
- `nix/hosts/laptop/` — host config + `hardware-configuration.nix` **placeholder**
- `nix/modules/` — one module per settled subtree (greetd, niri, portals, waybar,
  swaync, idle/lock, fuzzel, env, HM wiring)
- `<app>/.config/<app>/…` — the verbatim configs ("Option A", no Nix rewrite):
  - **Hot-reload** (out-of-store symlinks, edit + reload, no rebuild):
    niri `config.kdl`, waybar `config.jsonc`/`style.css`/`colors.css`,
    swaync `style.css`
  - **Set-and-forget** (committed store symlinks, rebuild to change):
    swayidle, swaylock, swaync `config.json`, fuzzel

## Deploying on the laptop

1. Clone this repo to `~/dotfiles` (if elsewhere, adjust `repo` in
   `nix/modules/home.nix`).
2. Replace the placeholder hardware config:
   `sudo nixos-generate-config --show-hardware-config > nix/hosts/laptop/hardware-configuration.nix`
3. In `niri/.config/niri/config.kdl`, delete the `spawn-at-startup "waybar"`
   line — on NixOS waybar runs as a systemd user service (it stays for the
   old stow-based setup).
4. `sudo nixos-rebuild switch --flake ~/dotfiles/nix#laptop`

The flake sits in a subdirectory of the git repo, so its references to the
config files at the repo root (`../../swaync/…` etc.) work — but only for
files git knows about. `git add` new configs before rebuilding, or the flake
won't see them.

Daemons run as systemd user services bound to `graphical-session.target`:
`journalctl --user -u waybar` / `swaync` / `swayidle` for debugging,
`systemctl --user restart <svc>` after config edits.

## Open items

- `hosts/laptop/hardware-configuration.nix` is a stub — must come from the
  real machine (step 2 above).
- swayidle timeouts (300/360 s) are starter values — tune them in
  `swayidle/.config/swayidle/config`.
- swaync `style.css`/`config.json`, swaylock `config`, and `fuzzel.ini` are
  minimal placeholders — paste in your real ones anytime.
