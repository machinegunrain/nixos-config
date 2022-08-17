{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ waybar wf-recorder];
  # xdg.configFile."waybar".source = ../conf.d/waybar;
}
