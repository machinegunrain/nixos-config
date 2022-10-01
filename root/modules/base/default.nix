{ config, libs, pkgs, nixpkgs, ...}: {

  fonts.fonts = with pkgs; [
   noto-fonts-cjk
   noto-fonts-emoji
   aileron
   helvetica-neue-lt-std
   gyre-fonts
   (nerdfonts.override { fonts = ["Iosevka"];})
  ];

  # Nix Configuration
  nix.extraOptions = "experimental-features = nix-command flakes";
  nixpkgs.config.allowUnfree = true;


  # root packages
  environment.systemPackages = with pkgs; [
    wget parted git ntfs3g cachix libglvnd gnumake gcc
    libde265 openh264 faad2 xvidcore ffmpeg_5 libmad
    pavucontrol nerdfonts sqlite zlib.dev
    freeglut ghostscript inotify-tools
    libtool nasm autoconf automake libpng.dev libpng.out
  ];


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

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
    settings =  { General = { ControllerMode = "bredr"; };};
  };

  # Services
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

  # Networking
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # networking.hostName = specified by each host
  # networking.useDHCP = false;
  # networking.interfaces.eno0.useDHCP = true;
  # networking.interfaces.wls6.useDHCP = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 0 20 21 22 80 443 194 1194 3000 5432 8080 8888 57621];
  networking.firewall.allowedUDPPorts = [ 67 68 161 162];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
