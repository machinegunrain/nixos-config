{config, lib, pkgs, ... }: {
  imports = [
    ./python
    ./elixir
    ./bun
  ];

  home.packages = with pkgs; [nodejs dart];
}
