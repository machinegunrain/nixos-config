{config, pkgs, lib, ...}: {
  home.packages = with pkgs; [
    nodejs
    nodePackages.typescript-language-server
    nodePackages_latest.vscode-css-languageserver-bin];
}
