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
  };

  outputs = { self, nixpkgs, home-manager, niri, ... }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
        ./hosts/laptop
      ];
    };
  };
}
