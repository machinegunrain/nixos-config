{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ waybar wf-recorder];
}