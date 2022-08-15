{config, pkgs, lib, ... }:
{

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
    settings =  { General = { ControllerMode = "bredr"; };};
  };
}
