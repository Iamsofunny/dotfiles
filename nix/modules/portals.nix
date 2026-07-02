# Portals: gtk as default, wlr for screencast/screenshot.
#
# wlr is required because the gtk portal cannot do screen capture on
# wlroots-style compositors. The `config.niri` attrset below is rendered to
# niri-portals.conf, and only loads when XDG_CURRENT_DESKTOP=niri — which
# niri-session sets (see nix/modules/env.nix).
#
# mkForce: niri-flake pulls in / configures the GNOME portal by default;
# we suppress it entirely rather than double-enable.
#
# Note: xdg-desktop-portal-wlr needs PipeWire for screencast — enabled in
# hosts/laptop/default.nix.
{ pkgs, lib, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = lib.mkForce [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.niri = lib.mkForce {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };
}
