{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/env.nix
    ../../modules/greetd.nix
    ../../modules/niri.nix
    ../../modules/portals.nix
    ../../modules/home.nix
    ../../modules/waybar.nix
    ../../modules/swaync.nix
    ../../modules/idle-lock.nix
    ../../modules/fuzzel.nix
  ];

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";

  users.users.matze = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  # Waybar's bluetooth module needs BlueZ running.
  hardware.bluetooth.enable = true;

  # PipeWire is required by xdg-desktop-portal-wlr for screencast
  # (see nix/modules/portals.nix), and provides audio (wpctl binds in
  # niri/.config/niri/config.kdl).
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # obsidian is unfree.
  nixpkgs.config.allowUnfree = true;

  # Applications referenced by binds/rules in niri/.config/niri/config.kdl
  # and by the Waybar config.
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    nautilus
    obsidian
    keepassxc
    brightnessctl
    playerctl
    pasystray
    pulseaudio # pactl, used by the Waybar pulseaudio on-click
  ];

  # Waybar / fuzzel styling expects this font.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # Set to the release you first install with; do not bump afterwards.
  system.stateVersion = "25.11";
}
