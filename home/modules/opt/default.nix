{config, lib, pkgs, ... }: {
  imports = [
    ./discord
    ./spotify
  ];

  home.packages = with pkgs; [google-chrome gimp transmission-gtk];

}
