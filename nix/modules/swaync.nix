{ lib, ... }:

{
  home-manager.sharedModules = [{
    services.swaync.enable = true;

    xdg.configFile."swaync/config.json" = lib.mkForce { source = ../../swaync/.config/swaync/config.json; };
  }];
}
