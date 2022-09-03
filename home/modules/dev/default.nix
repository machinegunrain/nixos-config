{config, lib, pkgs, ... }: {
  imports = [
    ./python
    ./elixir
    ./bun
    ./node
  ];
}
