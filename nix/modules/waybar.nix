# Waybar as a systemd user service bound to graphical-session.target
# (restart-on-crash, ordered startup, `journalctl --user -u waybar`).
#
# HM owns only the UNIT. The config content is the verbatim
# waybar/.config/waybar/{config.jsonc,style.css,colors.css}, symlinked
# out-of-store in nix/modules/home.nix — do not set programs.waybar.settings
# or .style here.
{ ... }:

{
  home-manager.sharedModules = [{
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  }];
}
