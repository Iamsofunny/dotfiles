# fuzzel — on-demand launcher, not a daemon. Bound to Mod+D in
# niri/.config/niri/config.kdl.
#
# Verbatim INI on the committed-source path. If migrating to module form
# later, HM's programs.fuzzel is available — not now (Option A).
{ pkgs, ... }:

{
  home-manager.sharedModules = [{
    home.packages = [ pkgs.fuzzel ];

    xdg.configFile."fuzzel/fuzzel.ini".source =
      ../../fuzzel/.config/fuzzel/fuzzel.ini;
  }];
}
