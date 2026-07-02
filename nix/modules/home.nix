# Home Manager wiring (as a NixOS module — one `nixos-rebuild switch` builds
# system + user) and the "Option A" out-of-store symlinks.
#
# Hot-reload files live here as out-of-store symlinks: edit the file in the
# repo, reload the app — no rebuild. Set-and-forget files (committed,
# read-only store symlinks) live next to their unit modules
# (swaync.nix, idle-lock.nix, fuzzel.nix).
{ lib, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";

    users.matze = { config, ... }:
      let
        # Absolute path to this repo's checkout on the machine.
        # ADJUST if you clone it somewhere other than ~/dotfiles.
        # The repo uses a stow-style layout: <app>/.config/<app>/<file>.
        repo = "${config.home.homeDirectory}/dotfiles";
        link = path:
          config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
      in {
        home.stateVersion = "25.11";

        # mkForce guards against niri-flake's HM module also claiming
        # niri/config.kdl.
        xdg.configFile."niri/config.kdl" =
          lib.mkForce { source = link "niri/.config/niri/config.kdl"; };

        xdg.configFile."waybar/config.jsonc".source =
          link "waybar/.config/waybar/config.jsonc";
        xdg.configFile."waybar/style.css".source =
          link "waybar/.config/waybar/style.css";
        xdg.configFile."waybar/colors.css".source =
          link "waybar/.config/waybar/colors.css";
        xdg.configFile."waybar/power_menu.xml".source =
          link "waybar/.config/waybar/power_menu.xml";

        # mkForce guards against HM's swaync module also claiming style.css.
        xdg.configFile."swaync/style.css" =
          lib.mkForce { source = link "swaync/.config/swaync/style.css"; };
      };
  };
}
