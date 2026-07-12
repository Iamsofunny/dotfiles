# Shared host config — everything except bootloader, hostname and
# hardware-configuration.nix, which stay in hosts/<name>/default.nix.
{ pkgs, ... }:

{
  imports = [
    ../modules/env.nix
    ../modules/greetd.nix
    ../modules/niri.nix
    ../modules/portals.nix
    ../modules/home.nix
    ../modules/waybar.nix
    ../modules/swaync.nix
    ../modules/idle-lock.nix
    ../modules/fuzzel.nix
  ];

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Binary cache for niri-unstable (values from the niri-flake README) —
  # without it the rebuild compiles niri from source.
  nix.settings.substituters = [ "https://niri.cachix.org" ];
  nix.settings.trusted-public-keys =
    [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];

  # Unstable channel churns fast — GC weekly so old generations don't
  # fill the disk.
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  services.fstrim.enable = true; # SSD trim timer
  zramSwap.enable = true; # compressed RAM swap, no swap partition needed

  time.timeZone = "Europe/Berlin";

  # English language, German keyboard. console.keyMap covers the VT (tuigreet
  # login); XKB_DEFAULT_LAYOUT covers niri, whose bare `xkb {}` block falls
  # back to libxkbcommon's environment defaults — config.kdl stays layout-free
  # so the Fedora stow setup keeps its own layout.
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";
  environment.sessionVariables.XKB_DEFAULT_LAYOUT = "de";

  users.users.matze = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services.tailscale.enable = true;

  virtualisation.docker.enable = true;

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

  # obsidian and vscode are unfree.
  nixpkgs.config.allowUnfree = true;

  # Applications referenced by binds/rules in niri/.config/niri/config.kdl
  # and by the Waybar config.
  environment.systemPackages = with pkgs; [
    git # also required for flake rebuilds from ~/dotfiles
    htop
    # The fish config (fish/.config/fish) shells out to these:
    # zoxide init in config.fish; cat/ls/e aliased to bat/lsd/micro.
    zoxide
    bat
    lsd
    micro
    kitty
    firefox
    nautilus
    obsidian
    keepassxc
    vscode
    notepad-next
    libreoffice
    brightnessctl
    playerctl
    pasystray
    pulseaudio # pactl, used by the Waybar pulseaudio on-click
    pavucontrol # Waybar pulseaudio on-click-right
    unzip
    zip
    evince
    loupe
    gcc
    python3
  ];

  services.printing.enable = true;

  # USB sticks: unprivileged mounting + Nautilus integration
  # (click-to-mount under /run/media, or `udisksctl mount -b ...`).
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Waybar / fuzzel styling expects this font.
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # Set to the release you first install with; do not bump afterwards.
  system.stateVersion = "25.11";
}
