{ ... }:

{
  home-manager.sharedModules = [{
    services.syncthing = {
      enable = true;
      # Keep devices/folders managed via the web UI
      overrideDevices = false;
      overrideFolders = false;
    };
  }];

  # Sync + local discovery (home-manager can't touch the firewall)
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
