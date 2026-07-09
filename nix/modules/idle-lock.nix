# Idle + lock: swayidle is the single brain.
#
# Event wiring (timeouts, before-sleep, lock) lives in the verbatim
# swayidle/.config/swayidle/config — HM owns only the unit. All gtklock
# invocations there use `--daemonize` (fork only after the compositor
# reports the session locked, same guarantee as swaylock -f); without
# it, before-sleep returns before the screen is locked and you resume
# unlocked.
#
# Chain: lid close → logind suspends → PrepareForSleep → swayidle
# before-sleep → gtklock --daemonize. swayidle holds a sleep inhibitor
# lock itself (no unit ordering against sleep.target is needed for
# before-sleep to fire), and HM starts it with -w so the inhibitor is
# only released once the lock command returns. No separate systemd
# sleep-hook service.
{ ... }:

{
  # Package + PAM entry (/etc/pam.d/gtklock) — without PAM, gtklock
  # cannot authenticate the unlock. Also puts gtklock on the systemd
  # user PATH (/run/current-system/sw/bin), where swayidle invokes it.
  # The module's generated /etc/xdg/gtklock/config.ini is shadowed by
  # the user config below (gtklock checks ~/.config first).
  programs.gtklock.enable = true;

  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.sharedModules = [{
    # Unit only (bound to graphical-session.target); events come from the
    # config file. swayidle finds gtklock/niri on the systemd user PATH
    # (/run/current-system/sw/bin).
    services.swayidle.enable = true;

    # Set-and-forget, committed (Option A read-only path):
    xdg.configFile."swayidle/config".source =
      ../../swayidle/.config/swayidle/config;
    xdg.configFile."gtklock/config.ini".source =
      ../../gtklock/.config/gtklock/config.ini;
    xdg.configFile."gtklock/style.css".source =
      ../../gtklock/.config/gtklock/style.css;
  }];
}
