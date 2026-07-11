# Niri compositor (via niri-flake's NixOS module, imported in flake.nix).
#
# Config management is "Option A": the verbatim niri/.config/niri/config.kdl is
# symlinked out-of-store by nix/modules/home.nix. Do NOT set
# programs.niri.settings / programs.niri.config here — that would have
# niri-flake generate a config.kdl and fight the symlink.
{ pkgs, ... }:

{
  programs.niri.enable = true;

  # config.kdl is written against the niri master docs and uses features
  # newer than the tagged releases (maximize-window-to-edges, recent-windows).
  # niri-flake's default niri-stable rejects those nodes, and one bad node
  # makes niri discard the WHOLE config and run its built-in defaults —
  # which looks like "config not applied" plus the default bar spawn.
  # niri-unstable tracks master, matching the docs the config follows.
  programs.niri.package = pkgs.niri-unstable;

  environment.systemPackages = with pkgs; [
    # Needed for niri's built-in screenshot actions to copy to clipboard.
    wl-clipboard
  ];
}
