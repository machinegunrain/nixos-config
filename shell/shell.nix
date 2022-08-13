{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    gnumake glib nixpkgs-fmt
    ripgrep
    fish
  ];

  shellHook = ''
    export NIX_BUILD_SHELL=fish
  '';
}
