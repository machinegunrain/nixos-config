{ config, lib, pkgs, ... }:

{
  # List services that you want to enable:

  # Enable dbus
  services.dbus.enable = true;

  # Login through swaylock
  security.pam.services.swaylock.text = "auth include login";
  security.rtkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;};
}
