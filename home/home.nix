{ config, lib, pkgs, ... }:
{
  imports = [
    ./discord
    ./emacs
    ./firefox
    ./fish
    ./foot
    # ./gtk
    ./rofi
    ./sway
    ./waybar
  ];

  programs.home-manager.enable = true;
  home = { username = "dash";
           homeDirectory = "/home/dash";
           stateVersion  = "22.05";
           sessionVariables = {
              EDITOR = "emacsclient -n -c -a emacs";
           };
           keyboard = null;
           packages = with pkgs; [ htop unzip i2c-tools mako fd nix-prefetch-github
                                   fzf ripgrep
                                   neofetch texlive.combined.scheme-full
                                   mpv spotify geeqie ];
           };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
