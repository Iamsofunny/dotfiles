{ pkgs, ... }:
{
  home-manager.sharedModules = [{
    gtk = {
      enable = true;
      iconTheme = { name = "Adwaita"; package = pkgs.adwaita-icon-theme; };
      font = { name = "Noto Sans"; size = 10; };
    };
    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
    };
  }];
}
