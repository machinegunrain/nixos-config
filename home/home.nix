{ config, lib, pkgs, gnome, ... }:
{
  imports = [
    ./modules
    ./pls
  ];

  programs.home-manager.enable = true;
  home = { username = "dash";
           homeDirectory = "/home/dash";
           stateVersion  = "22.05";
           sessionVariables = {
              EDITOR = "emacsclient -n -c -a emacs";
           };
           keyboard = null;
           packages = with pkgs; [ nix-prefetch-github htop unzip i2c-tools dunst pass age
                                   fd ripgrep procs tldr exa bat tokei
                                   fzf neofetch texlive.combined.scheme-full
                                   mpv geeqie lsix ueberzug playerctl sioyek glow];
           };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
