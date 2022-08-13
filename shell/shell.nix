{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    gnumake glib
    nixpkgs-fmt
    ripgrep
    fish
  ];

  shellHook = ''
    fish
  '';
}
