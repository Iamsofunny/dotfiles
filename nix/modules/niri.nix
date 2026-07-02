# Niri compositor (via niri-flake's NixOS module, imported in flake.nix).
#
# Config management is "Option A": the verbatim niri/.config/niri/config.kdl is
# symlinked out-of-store by nix/modules/home.nix. Do NOT set
# programs.niri.settings / programs.niri.config here — that would have
# niri-flake generate a config.kdl and fight the symlink.
{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    # Needed for niri's built-in screenshot actions to copy to clipboard.
    wl-clipboard
  ];
}
