{ config, lib, pkgs, nixpkgs, ... }: {
  imports = [
    ./hardware/hardware-configuration.nix
    ./nvidia.nix
    ./boot.nix
    ./networking.nix
    ./system.nix
    ./services.nix
    ./users.nix
  ];

  # Nix Configuration
  nix.extraOptions = "experimental-features = nix-command flakes";
  nixpkgs.config.allowUnfree = true;


  # root packages
  environment.systemPackages = with pkgs; [
    wget parted git ntfs3g mesa cachix
    pavucontrol
  ];


  fonts.fonts = with pkgs; [
   noto-fonts-cjk
   noto-fonts-emoji
   (nerdfonts.override { fonts = ["Iosevka"];})
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
