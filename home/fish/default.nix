{ config, lib, pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      vi = "$EDITOR";};
    shellInit = ''
      set HOMECONF $HOME/nixos-config/home
      set ROOTCONF $HOME/nixos-config/root
    '';
    functions = {
      fish_greeting = "fortune";
      home-flake = "home-manager switch --flake $HOMECONF/#dash";
      root-flake = "sudo nixos-rebuild switch --flake $ROOTCONF/#";};
    plugins = [
      { name = "z";
        src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";};}
      { name = "hydro";
        src = pkgs.fetchFromGitHub {
        owner = "jorgebucaran";
        repo = "hydro";
        rev = "d4c107a2c99d1066950a09f605bffea61fc0efab";
        sha256 = "cQYT1EKlSev+FZe/zgeb3kzaqYOvZTJxFXbmwOk0UKo=";};}];
  };
}
