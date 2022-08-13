{ config, pkgs, lib, ... }:
  let swayEnv = import ./configs/wayland.nix {inherit config pkgs; };
  in {

  home = { username = "dash";
           homeDirectory = "/home/dash";
           stateVersion  = "22.05";
           keyboard = null;};

  home.packages = with pkgs; [ htop unzip i2c-tools wayland swaylock swayidle waybar wl-clipboard wofi mako
                               nix-prefetch-github
                               texlive.combined.scheme-full
                               mpv spotify ] ++ swayEnv;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.home-manager.enable = true;
  wayland.windowManager.sway = import ./configs/sway.nix { inherit config pkgs; };
  programs.foot = import ./configs/foot.nix { inherit pkgs; };

  programs.fish = import ./configs/fish.nix { inherit pkgs; };

  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;

  programs.java.enable = true;
  programs.java.package = pkgs.jdk11;
}
