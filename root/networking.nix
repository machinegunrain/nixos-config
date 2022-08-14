{ config, lib, pkgs, ... }:

{
 # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.hostName = "workspace";
  networking.useDHCP = false;
  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wls6.useDHCP = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 0 20 21 22 80 443 194 57621];
  networking.firewall.allowedUDPPorts = [ 67 68 161 162 ];
  # networking.firewall.enable = false;

}
