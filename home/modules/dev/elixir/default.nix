{config, lib, pkgs, ... }: {

  home.packages = with pkgs; [erlang  erlang-ls elixir elixir_ls];

}
