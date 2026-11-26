# NixOS helpers — Fedora shares this config via stow, so everything is
# guarded. Hostnames match the flake outputs (laptop, vm), so (hostname)
# picks the right nixosConfiguration automatically.
if test -e /etc/NIXOS
    alias update="sudo nix flake update --flake ~/dotfiles/nix"
    alias rebuild="sudo nixos-rebuild switch --flake ~/dotfiles/nix#(hostname)"
end
