{
  description = "NixOS laptop — Niri Wayland desktop (greetd/hyprlogin + waybar + swaync + hypridle/hyprlock + fuzzel)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nirimod = {
      url = "github:srinivasr/nirimod";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlogin = {
      url = "github:AuthenticSm1les/hyprlogin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, nirimod, hyprlogin, ... }:
    let
      mkHost = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
          { nixpkgs.overlays = [ niri.overlays.niri nirimod.overlays.default hyprlogin.overlays.default ]; }
          host
        ];
      };
    in {
      nixosConfigurations.laptop = mkHost ./hosts/laptop;
      nixosConfigurations.vm = mkHost ./hosts/vm;
    };
}
