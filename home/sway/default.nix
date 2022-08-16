{config, lib, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
  name = "dbus-sway-environment";
  destination = "/bin/dbus-sway-enviroment";
  executable = true;
  text = ''
     dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
     systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
     systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
     '';
  };
  modifier = config.wayland.windowManager.sway.config.modifier;

in
{ home.packages = with pkgs; [ wayland dbus-sway-environment swaylock swaybg swayidle wl-clipboard
                               grim slurp wlroots
                             ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.configFile."sway".source = ../conf.d/sway;
}
