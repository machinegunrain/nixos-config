{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "dvorak-programmer";

  # Enable wayland and gtk
  xdg.portal.enable = true;
  xdg.portal.extraPortals=with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };
}
