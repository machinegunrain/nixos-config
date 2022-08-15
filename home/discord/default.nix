{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ discord betterdiscordctl ];

  # xdg.configFile."BetterDiscord".source = ../conf.d/BetterDiscord;
}
