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

  # eviroment.systemPackages = with pkgs; [];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
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
