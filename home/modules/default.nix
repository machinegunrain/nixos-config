{config, lib, pkgs, ... }: {
  imports = [
    ./discord
    ./emacs
    ./firefox
    ./fish
    ./foot
    ./gtk
    ./rofi
    ./spotify
    ./sway
    ./waybar
  ];
}
