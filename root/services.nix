{ config, lib, pkgs, ... }:

{
  # List services that you want to enable:

  # Enable dbus
  services.dbus.enable = true;
  services.udisks2.enable = true;

  # Login through swaylock
  security.pam.services.swaylock.text = "auth include login";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire =
  { enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;};
}
