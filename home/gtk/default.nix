{config, lib, pkgs, ...}:
let
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
      gsettings set $gnome_schema gtk-theme 'Dracula';
  '';
  };

in
{
  home.packages = with pkgs; [
    configure-gtk gsettings
    dracula-theme gnome3.adwaita-icon-theme
  ];
}
