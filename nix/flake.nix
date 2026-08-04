{
  description = "NixOS laptop — Niri Wayland desktop (greetd + waybar + swaync + swayidle/gtklock + fuzzel)";

  inputs = {
    # nixos-unstable: Niri/swaync move fast, recent packages required.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Session plumbing, Niri-aware modules, portal wiring.
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GTK4 GUI config editor for niri; not packaged in nixpkgs.
    nirimod = {
      url = "github:srinivasr/nirimod";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, nirimod, ... }:
    let
      mkHost = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          # niri.overlays.niri exposes pkgs.niri-unstable (git master),
          # selected in modules/niri.nix — the verbatim config.kdl uses
          # master features. nirimod.overlays.default exposes pkgs.nirimod.
          { nixpkgs.overlays = [ niri.overlays.niri nirimod.overlays.default ]; }
          host
        ];
      };
    in {
      nixosConfigurations.laptop = mkHost ./hosts/laptop;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
