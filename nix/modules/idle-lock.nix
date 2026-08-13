{ ... }:

{
  programs.gtklock.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.sharedModules = [{
    services.swayidle.enable = true;

    xdg.configFile."swayidle/config".source = ../../swayidle/.config/swayidle/config;
    xdg.configFile."gtklock/config.ini".source = ../../gtklock/.config/gtklock/config.ini;
    xdg.configFile."gtklock/style.css".source = ../../gtklock/.config/gtklock/style.css;
  }];
}
