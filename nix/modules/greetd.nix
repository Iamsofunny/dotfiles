{ config, lib, pkgs, ... }:

let
  niri = lib.getExe config.programs.niri.package;
  hyprlogin = lib.getExe pkgs.hyprlogin;
  greeterUser = config.services.greetd.settings.default_session.user;
  desktops = config.services.displayManager.sessionData.desktops;

  # Minimal, locked-down Niri config for the greeter session:
  # matches system German keyboard layout, suppresses the startup hotkey
  # overlay, and leaves `binds {}` empty so no launcher/terminal hotkeys
  # exist on the login screen.
  greeterNiriConfig = pkgs.writeText "niri-greeter.kdl" ''
    input {
        keyboard {
            xkb {
                layout "de"
            }
            numlock
        }
    }

    hotkey-overlay {
        skip-at-startup
    }

    binds {
    }
  '';
in
{
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${niri} -c ${greeterNiriConfig} -- ${pkgs.runtimeShell} -c '${hyprlogin}; ${niri} msg action quit --skip-confirmation'";
  };

  # hyprlogin reads /etc/hyprlogin/hyprlogin.conf as the `greeter` user.
  # Sessions come from NixOS's session registry, not /usr/share, and
  # general:exit_command is cleared because the greeter wrapper quits Niri
  # cleanly as soon as hyprlogin exits.
  environment.etc."hyprlogin/hyprlogin.conf".text = ''
    source = ${../../hyprlogin/hyprlogin.conf}

    general {
        exit_command =
    }

    sessions {
        wayland_path = ${desktops}/share/wayland-sessions
        x11_path = ${desktops}/share/xsessions
        default_user = matze
        default_session = niri.desktop
    }
  '';

  # Cache for sessions:remember_user / remember_session.
  systemd.tmpfiles.settings.hyprlogin."/var/cache/hyprlogin".d = {
    user = greeterUser;
    group = config.users.users.${greeterUser}.group or greeterUser;
    mode = "0750";
  };

  environment.systemPackages = [ pkgs.hyprlogin ];
}
