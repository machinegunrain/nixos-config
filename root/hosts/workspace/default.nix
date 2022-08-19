{ config, lib, pkgs, nixpkgs, ... }:
{ imports = [
    ./hardware/hardware-configuration.nix
  ];

  # Networking
  networking.hostName = "workspace";

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Users
  users.users.dash = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound"];
    shell = pkgs.fish;
 };

  environment.sessionVariables = {
    EDITOR = "emacsclient -n -c -a emacs";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-id/usb-StoreJet_TS240GESD350C_C121430EF299203E0000-0:0-part2";
    keyFile = "/dev/disk/by-id/usb-Generic_USB_Flash_Disk_000000001530-0:0";
    keyFileSize = 4096;
    preLVM = true;
    allowDiscards = true;
  };

}