{ config, lib, pkgs, ... }:

{
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;
  programs.doom-emacs.enable = true;
  programs.doom-emacs.doomPrivateDir = ./doom.d;
}
