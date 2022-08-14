{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dash = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound"];
    shell = pkgs.fish;
 };
}
