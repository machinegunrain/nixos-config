{config, lib, pkgs, ... }: {
  home.packages = with pkgs; [erlang elixir_1_14 elixir_ls];}
