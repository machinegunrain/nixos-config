{config, lib, pkgs, ... }: {
  imports = [
    ./base
    ./discord
    ./spotify
  ];
}
