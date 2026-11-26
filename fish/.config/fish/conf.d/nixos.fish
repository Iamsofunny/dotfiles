# NixOS helpers — Fedora shares this config via stow, so everything is
# guarded. Hostnames match the flake outputs (laptop, vm), so (hostname)
# picks the right nixosConfiguration automatically.
if test -e /etc/NIXOS
    function update --description "Update Nix flake inputs and commit/push flake.lock"
        set -l repo ~/dotfiles
        nix flake update --flake $repo/nix $argv; or return $status

        if not git -C $repo diff --quiet -- nix/flake.lock
            git -C $repo add nix/flake.lock; or return $status
            git -C $repo commit -m "update flake.lock ("(date '+%Y-%m-%d %H:%M')")" -- nix/flake.lock; or return $status
            git -C $repo push
        end
    end

    function rebuild --description "Rebuild NixOS and commit/push dotfiles on success"
        set -l repo ~/dotfiles
        set -l nix_args
        set -l msg_parts

        for arg in $argv
            if string match -q -- '-*' $arg
                set -a nix_args $arg
            else
                set -a msg_parts $arg
            end
        end

        set -l msg "rebuild ("(hostname)"): "(date '+%Y-%m-%d %H:%M')
        if test (count $msg_parts) -gt 0
            set msg (string join ' ' $msg_parts)
        end

        # Ensure new files are visible to the flake before building.
        git -C $repo add -N .; or return $status

        sudo nixos-rebuild switch --flake $repo/nix#(hostname) $nix_args; or return $status

        set -l dirty (git -C $repo status --porcelain)
        if test (count $dirty) -gt 0
            git -C $repo add -A; or return $status
            git -C $repo commit -m "$msg"; or return $status
            git -C $repo push
        end
    end
end
