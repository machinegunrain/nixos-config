{config, lib, pkgs, unstable, ...}:
{
  home.packages = with pkgs; [
    glib gnome3.adwaita-icon-theme
    xsettingsd pop-gtk-theme pop-icon-theme capitaine-cursors
    at-spi2-core dconf nordic papirus-icon-theme pcmanfm
  ];

  gtk.enable = true;
  gtk.font.name = "aileron";
  gtk.font.package = pkgs.aileron;
  gtk.theme.name = "Nordic";
  gtk.theme.package = pkgs.nordic;
  gtk.iconTheme.name = "Papirus-Dark";  # Candy and Tela also look good
  gtk.iconTheme.package = pkgs.papirus-icon-theme;
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
    gtk-key-theme-name    = "Emacs";
    gtk-icon-theme-name   = "Papirus-Dark";
    gtk-cursor-theme-name = "capitaine-cursors";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-key-theme = "Emacs";
      cursor-theme = "Capitaine Cursors";
    };
  };
  xdg.systemDirs.data = [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];

}
