{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [spotify spicetify-cli];
  xdg.configFile."spicetify".source = ../conf.d/spicetify;
}
