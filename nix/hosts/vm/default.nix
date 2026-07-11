{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "vm";

  # BIOS boot with GRUB (typical VM setup). /dev/vda is the qemu/virtio
  # disk — change to /dev/sda for a SATA/IDE virtual disk.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
}
