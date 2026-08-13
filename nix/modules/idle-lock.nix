{ config, ... }:

let
  gtklock = "${config.programs.gtklock.package}/bin/gtklock --daemonize";
  niri = "${config.programs.niri.package}/bin/niri";
in
{
  programs.gtklock.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.sharedModules = [{
    services.swayidle = {
      enable = true;

      timeouts = [
        {
          timeout = 300;
          command = gtklock;
        }
        {
          timeout = 360;
          command = "${niri} msg action power-off-monitors";
          resumeCommand = "${niri} msg action power-on-monitors";
        }
      ];

      events = {
        before-sleep = gtklock;
        lock = gtklock;
      };
    };

    xdg.configFile."gtklock/config.ini".source = ../../gtklock/.config/gtklock/config.ini;
    xdg.configFile."gtklock/style.css".source = ../../gtklock/.config/gtklock/style.css;
  }];
}
