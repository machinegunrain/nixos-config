{config, lib, pkgs, ...}:
let
  configure-gtk = pkgs.writeTextFile {
  name = "configure-gtk";
  destination = "/bin/configure-gtk";
  executable = true;
  text = let
  schema = pkgs.gsettings-desktop-schemas;
  datadir = "${schema}/share/gsetting-schemas/${schema.name}";
  in ''
      export XDG_DATA_DIR=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme "Nordic"
  '';
  };

in
{
  home.packages = with pkgs; [
    configure-gtk glib gnome3.adwaita-icon-theme
    xsettingsd
  ];

  home.file.".themes".source = ./themes;

}
