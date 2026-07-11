# ── PLACEHOLDER ──────────────────────────────────────────────────────────────
# Replace this file with the one generated inside the VM:
#
#   sudo nixos-generate-config --show-hardware-config > hosts/vm/hardware-configuration.nix
#
# (or copy /etc/nixos/hardware-configuration.nix after the installer ran).
# The stub below only exists so the flake evaluates before that happens.
# ─────────────────────────────────────────────────────────────────────────────
{ lib, ... }:

{
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
