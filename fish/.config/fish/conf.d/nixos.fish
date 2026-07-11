# NixOS helpers — Fedora shares this config via stow, so everything is
# guarded. Hostnames match the flake outputs (laptop, vm), so (hostname)
# picks the right nixosConfiguration automatically.
if test -e /etc/NIXOS
    # Rebuild + activate this host from the flake
    alias nrs="sudo nixos-rebuild switch --flake ~/dotfiles/nix#(hostname)"
    # Activate without a boot entry — reverts on reboot, good for trying things
    alias nrt="sudo nixos-rebuild test --flake ~/dotfiles/nix#(hostname)"
    # Update flake inputs (nixpkgs, home-manager, niri)
    alias nup="nix flake update --flake ~/dotfiles/nix"
    # Free space: drop generations older than a week, dedupe the store
    alias ngc="sudo nix-collect-garbage --delete-older-than 7d && sudo nix store optimise"
    # List system generations (what nrs/rollback switch between)
    alias ngens="nixos-rebuild list-generations"
end
