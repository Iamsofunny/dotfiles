# swaync — the sole notification daemon (no mako/dunst anywhere).
# Daemon + control center run via the HM systemd user service, bound to
# graphical-session.target.
#
# Config content stays verbatim (Option A):
#   - config.json  → committed, read-only store symlink (below)
#   - style.css    → out-of-store symlink for live theming (nix/modules/home.nix)
{ lib, ... }:

{
  home-manager.sharedModules = [{
    services.swaync.enable = true;

    # mkForce guards against HM's swaync module also claiming config.json.
    xdg.configFile."swaync/config.json" =
      lib.mkForce { source = ../../swaync/.config/swaync/config.json; };
  }];
}
