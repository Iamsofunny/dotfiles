{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "laptop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The ACPI firmware backlight (acpi_video0) is non-functional on this laptop:
  # it sits pinned at max while the panel is actually driven by amdgpu_bl*.
  # systemd-backlight prefers firmware devices over raw ones on the same PCI
  # device, so it saved/restored acpi_video0 and skipped amdgpu_bl* entirely —
  # which is why brightness was not restored across reboots. Dropping the
  # firmware device leaves amdgpu_bl* as the only backlight, and systemd
  # restores it correctly.
  boot.kernelParams = [ "acpi_backlight=native" ];
}
