{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];

  buildInputs = [
  ];

  shellHook = ''
  '';
}
