{ config, lib, pkgs, nixpkgs, ... }:
{ imports = [
    ./hardware/hardware-configuration.nix
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./users.nix
  ];

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

  # Nix Configuration
  nix.extraOptions = "experimental-features = nix-command flakes";
  nixpkgs.config.allowUnfree = true;


  # root packages
  environment.systemPackages = with pkgs; [
    wget parted git ntfs3g cachix libglvnd
    libde265 openh264 faad2 xvidcore ffmpeg_5 libmad
    pavucontrol nerdfonts zlib ranger
    freeglut cudatoolkit ghostscript
  ];

  environment.sessionVariables = {
    EDITOR = "emacsclient -n -c -a emacs";
  };


  fonts.fonts = with pkgs; [
   noto-fonts-cjk
   noto-fonts-emoji
   aileron
   gyre-fonts
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
