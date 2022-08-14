{ config, lib, pkgs, ... }:
let
  extra = import ./extra.nix { inherit config pkgs; };
in  {
  imports = [
    ./emacs
    ./firefox
    ./fish
    ./foot
    ./sway
  ];

  programs.home-manager.enable = true;
  home = { username = "dash";
           homeDirectory = "/home/dash";
           stateVersion  = "22.05";
           sessionVariables = {
              moz_enable_wayland = 1;
              xdg_current_desktop = "sway";
           };
           keyboard = null;
           packages = with pkgs; [ htop unzip i2c-tools wayland swaylock swayidle waybar wl-clipboard wofi mako fd
                                   nix-prefetch-github neofetch fortune
                                   texlive.combined.scheme-full
                                   mpv spotify ] ++ extra;
           };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;



}
