# Environment — three-sink rule:
#
#   1. System-universal vars        → environment.sessionVariables (this file)
#   2. Compositor-scoped vars       → `environment {}` block in
#                                     niri/.config/niri/config.kdl
#                                     (XCURSOR_*, QT_QPA_PLATFORM, ...)
#   3. Shell-only conveniences      → home.sessionVariables (editor, pager).
#                                     NOTHING a daemon depends on goes there —
#                                     daemons see the systemd-imported
#                                     environment, never the login shell.
#
# niri-session runs `systemctl --user import-environment` and starts
# graphical-session.target — that is what makes the systemd daemon model
# (waybar/swaync/swayidle units) work. It also sets XDG_CURRENT_DESKTOP=niri,
# which the portal routing in nix/modules/portals.nix keys off.
{ ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
