{ config, pkgs, lib, ... }:
  let
    dbus-sway-environment = pkgs.writeTextFile {
                            name = "dbus-sway-environment";
                            destination = "/bin/dbus-sway-enviroment";
			    executable = true;

                            text = ''
     dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
     systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
     systemctl --uses start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
     '';
     };

    configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configue-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsetting-schemas/${schema.name}";
      in ''
         export XDG_DATA_DIR=${datadir}:$XDG_DATA_DIRS
         gnome_schema=org.gnom.desktop.interface
         gsettings set $gnome_schema gtk-theme 'Catppuccin
      '';
  };

  swayEnv = [ dbus-sway-environment configure-gtk ];
in {

  home = {
  username = "dash";
  homeDirectory = "/home/dash";
  stateVersion  = "22.05";
  keyboard = null;

  };

  home.packages = with pkgs; [
    htop gnumake glib unzip i2c-tools
    wayland swaylock swayidle waybar
    mpv spotify
    wofi mako
    wl-clipboard
    texlive.combined.scheme-full
  ] ++ swayEnv;

  programs.home-manager.enable = true;
  programs.fish.enable = true;

  programs.vscode = {
    enable=true;
    package = pkgs.vscodium;};

  programs.java = {
    enable = true;
    package = pkgs.jdk11;};

  programs.foot = {
    enable = true;
      settings = {
      main = {
      term = "xterm-256color";
      font = "PragmataPro Mono Liga:size=12";
      dpi-aware = "yes";
      };
      mouse = {
      hide-when-typing = true;
      };
      colors = {
      foreground="d9e0ee";
background="1e1e2e";
selection-foreground="1e1e2e";
selection-background="d9e0ee";
regular0="6e6c7e";  # black
regular1="f28fad";  # red
regular2="abe9b3";  # green
regular3="fae3b0";  # yellow
regular4="96cdfb";  # blue
regular5="f5c2e7";  # magenta
regular6="89dceb";  # cyan
regular7="d9e0ee";  # white
bright0="988ba2";   # bright black
bright1="f28fad";   # bright red
bright2="abe93b";   # bright green
bright3="fae3b0";   # bright yellow
bright4="96cdfb";   # bright blue
bright5="f5c2e7";   # bright magenta
bright6="89dceb";   # bright cyan
bright7="d9e0ee";   # bright white
      };
      };
  };

  wayland.windowManager.sway = import ./configs/sway.nix { inherit config pkgs; };
}
