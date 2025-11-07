{ config, lib, pkgs, ... }:

{
  # Gaming-specific firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 27015 27016 27017 27018 27019 27020 27025 27030 ];
    allowedUDPPorts = [ 27000 27001 27015 27031 27036 3478 4379 4380 ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27100; }
      { from = 3478; to = 4380; }
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; }
    ];
  };
}