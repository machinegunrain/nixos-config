{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [spotify spicetify-cli];
  home.file."config/spicetify/Themes".source = ../conf.d/spicetify/Themes;
  # xdg.configFile."spicetify".source = ../conf.d/spicetify;
}
