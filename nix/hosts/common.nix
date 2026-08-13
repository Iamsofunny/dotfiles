# Shared host config — everything except bootloader, hostname and
# hardware-configuration.nix, which stay in hosts/<name>/default.nix.
{ config, pkgs, ... }:

{
  imports = [
    ../modules/env.nix
    ../modules/fuzzel.nix
    ../modules/greetd.nix
    ../modules/home.nix
    ../modules/idle-lock.nix
    ../modules/niri.nix
    ../modules/portals.nix
    ../modules/swaync.nix
    ../modules/theme.nix
    ../modules/waybar.nix
  ];

  # NixOS
  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://niri.cachix.org" ];
  nix.settings.trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  nixpkgs.config.allowUnfree = true;


  # System Settings
  ## Time
  time.timeZone = "Europe/Berlin";

  ## Locale/Keyboard
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";
  environment.sessionVariables.XKB_DEFAULT_LAYOUT = "de";

  ## Theming
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono pkgs.noto-fonts ];


  # System
  services.fstrim.enable = true; # SSD trim timer
  zramSwap.enable = true; # compressed RAM swap, no swap partition needed
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  ## Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ## Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  ## Printing
  services.printing.enable = true;
  services.avahi = { # discovery of network printers over mDNS/DNS-SD
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  ## USB mounting
  services.udisks2.enable = true;
  services.gvfs.enable = true;


  # Networking
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openconnect ];
  };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];


  # User
  users.users.matze = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.fish;
  };


  # Software
  programs.fish.enable = true;
  virtualisation.docker.enable = true;
  services.tailscale.enable = true;


  environment.systemPackages = with pkgs; [
    # System
    gnome-keyring
    ## Theme
    adwaita-icon-theme # symbolic icons for GTK apps
    ## Control
    brightnessctl
    playerctl
    pulseaudio
    pavucontrol
    networkmanagerapplet
    ## Software
    swaybg # Wallpaper
    syncthing # File Syncing

    # Shell
    kitty
    ## Programms
    bat # cat replacement
    btop # System Overview
    claude-code
    lsd # ls replacement
    micro # Editor
    openconnect # VPN client
    rclone
    tealdeer # tldr
    unzip
    zip
    zoxide # cd replacement

    # Code
    gcc # C++ compiler
    git
    (python3.withPackages (python-pkgs: with python-pkgs; [
      psutil
    ]))

    # Software
    evince # Document viewer
    firefox
    keepassxc
    libreoffice
    loupe # Image viewer
    nautilus
    nirimod
    notepad-next
    obsidian
    obs-studio
    thunderbird # Mail client
    vlc # Media Player
    vscode
  ];
}
