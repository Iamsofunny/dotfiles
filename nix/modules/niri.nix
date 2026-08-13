{ pkgs, ... }:

{
  programs.niri.enable = true;

  programs.niri.package = pkgs.niri-unstable;

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
