# dotfiles + NixOS flake

Stow-style dotfiles (`<app>/.config/<app>/…`) plus a NixOS flake (in `nix/`)
that builds a Niri Wayland desktop for a single laptop
(`nixosConfigurations.laptop`).

## Layout

- `nix/flake.nix` — inputs: nixos-unstable, home-manager (as NixOS module), niri-flake
- `nix/hosts/common.nix` — everything shared between hosts
- `nix/hosts/laptop/` (systemd-boot) and `nix/hosts/vm/` (GRUB, BIOS) —
  bootloader + hostname + `hardware-configuration.nix` **placeholder** each
- `nix/modules/` — one module per settled subtree (greetd, niri, portals, waybar,
  swaync, idle/lock, fuzzel, env, HM wiring)
- `<app>/.config/<app>/…` — the verbatim configs ("Option A", no Nix rewrite):
  - **Hot-reload** (out-of-store symlinks, edit + reload, no rebuild):
    niri `config.kdl`, waybar `config.jsonc`/`style.css`/`colors.css`,
    swaync `style.css`
  - **Set-and-forget** (committed store symlinks, rebuild to change):
    swayidle, gtklock, swaync `config.json`, fuzzel

## Deploying on the laptop

1. Clone this repo to `~/dotfiles` — **required**, the hot-reload configs
   (niri, waybar, fish, kitty, swaync style) are out-of-store symlinks into
   this exact path; without it they dangle and the apps fall back to their
   defaults. If cloned elsewhere, adjust `repo` in `nix/modules/home.nix`.
2. Replace the placeholder hardware config:
   `sudo nixos-generate-config --show-hardware-config > nix/hosts/laptop/hardware-configuration.nix`
3. `sudo nixos-rebuild switch --flake ~/dotfiles/nix#laptop`

Same for the VM with `hosts/vm/hardware-configuration.nix` and `#vm`
(GRUB on `/dev/vda` — adjust `boot.loader.grub.device` in
`nix/hosts/vm/default.nix` if the virtual disk isn't virtio).

No config.kdl edits are needed per machine: the Fedora-only starters
(`launch-waybar`, swaync) no-op on NixOS via an `/etc/NIXOS` guard.

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
- swaync `style.css`/`config.json` and `fuzzel.ini` are minimal
  placeholders — paste in your real ones anytime.
