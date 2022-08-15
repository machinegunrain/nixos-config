{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ firefox-wayland ];
  home.sessionVariables = {
    moz_enable_wayland = 1;
    xdg_current_desktop = "sway";
  };
}
