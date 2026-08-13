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

        xdg.configFile."niri/config.kdl" = lib.mkForce { source = link "niri/.config/niri/config.kdl"; };

        xdg.configFile."swaync/style.css" = lib.mkForce { source = link "swaync/.config/swaync/style.css"; };

        xdg.configFile."fish".source = link "fish/.config/fish";
        xdg.configFile."kitty".source = link "kitty/.config/kitty";
        xdg.configFile."waybar".source = link "waybar/.config/waybar";
      };
  };
}
