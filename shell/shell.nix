{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
  buildInputs = [
    gnumake glib nixpkgs-fmt
    ripgrep fish
    xorg.xkbcomp xorg.setxkbmap
  ];

  shellHook = ''
  '';
}
