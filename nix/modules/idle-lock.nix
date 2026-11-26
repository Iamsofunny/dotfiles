{ config, lib, pkgs, ... }:

let
  hyprlock = lib.getExe pkgs.hyprlock;
  pidof = lib.getExe' pkgs.procps "pidof";
  niri = lib.getExe config.programs.niri.package;
in
{
  # Required by Home Manager's programs.hyprlock so hyprlock can authenticate
  # via PAM. We intentionally do NOT set NixOS `programs.hyprlock.enable`
  # because nixpkgs's NixOS module enables NixOS `services.hypridle`, which
  # pulls Hyprland into the closure.
  security.pam.services.hyprlock = { };

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.sharedModules = [{
    # Installs pkgs.hyprlock; config is hot-reloaded via nix/modules/home.nix.
    programs.hyprlock.enable = true;

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "${pidof} hyprlock || ${hyprlock}";
          before_sleep_cmd = "${pidof} hyprlock || ${hyprlock} --immediate-render";
          after_sleep_cmd = "${niri} msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "${pidof} hyprlock || ${hyprlock}";
          }
          {
            timeout = 360;
            on-timeout = "${niri} msg action power-off-monitors";
            on-resume = "${niri} msg action power-on-monitors";
          }
        ];
      };
    };

    # Keep an active hyprlock alive if hypridle restarts (e.g. during rebuild):
    # killing a running ext-session-lock client leaves the compositor stuck locked.
    systemd.user.services.hypridle.Service.KillMode = "process";
  }];
}
