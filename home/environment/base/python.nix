{config, lib, pkgs, ... }: {

  home.packages = with pkgs;
    [ python310Full micromamba
    ];
}