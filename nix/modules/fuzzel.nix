{ pkgs, ... }:

{
  home-manager.sharedModules = [{
    home.packages = [ pkgs.fuzzel ];

    xdg.configFile."fuzzel/fuzzel.ini".source = ../../fuzzel/.config/fuzzel/fuzzel.ini;
  }];
}
