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
        repo = "${config.home.homeDirectory}/dotfiles";
        link = path:
          config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
      in {
        home.stateVersion = "25.11";

        # mkForce guards against niri-flake's HM module also claiming
        # niri/config.kdl.
        xdg.configFile."niri/config.kdl" =
          lib.mkForce { source = link "niri/.config/niri/config.kdl"; };

        # mkForce guards against HM's swaync module also claiming style.css.
        xdg.configFile."swaync/style.css" =
          lib.mkForce { source = link "swaync/.config/swaync/style.css"; };

        xdg.configFile."fish".source = link "fish/.config/fish";
        xdg.configFile."kitty".source = link "kitty/.config/kitty";
        xdg.configFile."waybar".source = link "waybar/.config/waybar";
      };
  };
}
