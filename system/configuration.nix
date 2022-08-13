{ config, lib, pkgs, nixpkgs, ... }: {
  
  imports = [ ./hardware-configuration.nix ];

  nix.extraOptions = "experimental-features = nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  
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

  networking.hostName = "workspace";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.useDHCP = false;
  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wls6.useDHCP = true;

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "dvorak-programmer";

  environment.systemPackages = with pkgs; [
    vim wget parted git ntfs3g mesa
    pavucontrol
    firefox
  ];

  security.pam.services.swaylock.text = "auth include login";
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dash = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound"];
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
};

  xdg.portal.enable = true;
  xdg.portal.extraPortals=with pkgs; [ 
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 0 20 21 22 80 443 194 57621];
  networking.firewall.allowedUDPPorts = [ 67 68 161 162 ];
  # networking.firewall.enable = false;

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
        # patches = oa.patches ++ [ ./mesa-vulkan-layer-nvidia.patch ];
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
