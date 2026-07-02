# Session entry: greetd + tuigreet.
#
# The command is `niri-session`, NEVER bare `niri` — bare `niri` skips the
# session environment import and graphical-session.target plumbing, which
# breaks the systemd user services (waybar/swaync/swayidle).
{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
  };
}
