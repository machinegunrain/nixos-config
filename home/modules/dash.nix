{config, lib, pkgs, ... }: {
  imports = [
    ./base
    ./discord
    ./spotify
    ./base/languages/elixir
  ];
}
