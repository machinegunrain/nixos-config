{config, pkgs, ...}:
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

in [ dbus-sway-environment configure-gtk ]
