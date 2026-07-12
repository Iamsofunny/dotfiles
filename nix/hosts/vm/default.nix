{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "vm";

  # BIOS boot with GRUB on a SATA/IDE virtual disk. For a qemu/virtio
  # disk, change to /dev/vda.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
}
