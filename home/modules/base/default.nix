{ config, lib, pkgs, gnome, ... }:

{
  imports = [
    ./emacs
    ./firefox
    ./fish
    ./foot
    ./gtk
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
           packages = with pkgs; [ nix-prefetch-github htop unzip i2c-tools dunst pass age xsel
                                   fzf neofetch  fd ripgrep procs tldr exa bat tokei zoxide
                                   mpv geeqie lsix ueberzug playerctl sioyek glow xdg-utils];
           };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
