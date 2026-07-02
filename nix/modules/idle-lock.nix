# Idle + lock: swayidle is the single brain.
#
# Event wiring (timeouts, before-sleep, lock) lives in the verbatim
# swayidle/.config/swayidle/config — HM owns only the unit. All swaylock
# invocations there use `-f` (fork after the lock surface is up); without
# it, before-sleep returns before the screen is locked and you resume
# unlocked.
#
# Chain: lid close → logind suspends → PrepareForSleep → swayidle
# before-sleep → swaylock -f. swayidle holds a sleep inhibitor lock itself
# (no unit ordering against sleep.target is needed for before-sleep to
# fire), and HM starts it with -w so the inhibitor is only released once
# the lock command returns. No separate systemd sleep-hook service.
{ pkgs, ... }:

{
  # PAM entry — without this, swaylock cannot authenticate the unlock.
  programs.swaylock.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.sharedModules = [{
    # Unit only (bound to graphical-session.target); events come from the
    # config file. swayidle finds swaylock/niri on the systemd user PATH
    # (/run/current-system/sw/bin).
    services.swayidle.enable = true;

    # Set-and-forget, committed (Option A read-only path):
    xdg.configFile."swayidle/config".source =
      ../../swayidle/.config/swayidle/config;
    xdg.configFile."swaylock/config".source =
      ../../swaylock/.config/swaylock/config;
  }];
}
