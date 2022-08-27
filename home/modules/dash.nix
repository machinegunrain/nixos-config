{config, lib, pkgs, ... }: {
  imports = [
    ./base
    ./opt
    ./dev
  ];
}
