{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    nixpkgs-fmt
    ripgrep
    fish
  ];

  shellHook = ''
    fish
  '';
}
