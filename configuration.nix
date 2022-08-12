# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

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

  networking.hostName = "workspace"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.useDHCP = false;
  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wls6.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "dvorak-programmer";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };


  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
nixpkgs.overlays =
  let
    # Change this to a rev sha to pin
    moz-rev = "master";
    moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";};
    nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
  in [
    nightlyOverlay
  ];
  environment.systemPackages = with pkgs; [
    vim wget parted git ntfs3g mesa
    bluezFull pavucontrol
    latest.firefox-nightly-bin
    cachix
  ];
  

  nix = {
    settings.trusted-users = [ "root" "dash" ];
    extraOptions = "experimental-features = nix-command flakes";
   };

  security.pam.services.swaylock = {
    text = "auth include login";
  };

  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # media-session.enable = true;
    pulse.enable = true;
};

  xdg = { portal = { enable=true;
                     extraPortals=with pkgs; [ xdg-desktop-portal-wlr
                                               xdg-desktop-portal-gtk];};};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dash = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound"];
    shell = pkgs.fish;
 };


  # Begin home-manager directives
  home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
   }; 

  fonts.fonts = with pkgs; [
   noto-fonts-cjk
   (nerdfonts.override { fonts = ["Iosevka"];})
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 0 20 21 22 80 443 194 57621];
  networking.firewall.allowedUDPPorts = [ 67 68 161 162 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = true;
    settings =  { General = { ControllerMode = "bredr"; };};
  };

  services.dbus.enable = true;
hardware = {
  opengl =
    let
      fn = oa: {
        nativeBuildInputs = oa.nativeBuildInputs ++ [ pkgs.glslang ];
        mesonFlags = oa.mesonFlags ++ [ "-Dvulkan-layers=device-select,overlay" ];
#       patches = oa.patches ++ [ ./mesa-vulkan-layer-nvidia.patch ]; See below 
        postInstall = oa.postInstall + ''
            mv $out/lib/libVkLayer* $drivers/lib

            #Device Select layer
            layer=VkLayer_MESA_device_select
            substituteInPlace $drivers/share/vulkan/implicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"

            #Overlay layer
            layer=VkLayer_MESA_overlay
            substituteInPlace $drivers/share/vulkan/explicit_layer.d/''${layer}.json \
              --replace "lib''${layer}" "$drivers/lib/lib''${layer}"
          '';
      };
    in
    with pkgs; {
      enable = true;
      driSupport32Bit = true;
      package = (mesa.overrideAttrs fn).drivers;
      package32 = (pkgsi686Linux.mesa.overrideAttrs fn).drivers;
    };

};
}
