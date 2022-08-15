{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # extraGroup explain
  # wheel - add user to sudo group
  # networkmanager - add permission to change network settings
  # sound - enable sound
  # input uinput kmonad - use kmonad as keyboard layout modifier
  users.users.dash = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound" "input" "uinput" "kmonad" ];
    shell = pkgs.fish;
 };
}
