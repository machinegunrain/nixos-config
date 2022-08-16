{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [spotify-unwrapped spicetify-cli];
  home.file."config/spicetify/Themes".source = ../conf.d/spicetify/Themes;
  # xdg.configFile."spicetify".source = ../conf.d/spicetify;
}
