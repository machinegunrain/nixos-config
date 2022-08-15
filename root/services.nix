{ config, lib, pkgs, ... }:

{
  # List services that you want to enable:

  # Enable dbus
  services.dbus.enable = true;
  services.udisks2.enable = true;

  # Login through swaylock
  security.pam.services.swaylock.text = "auth include login";
  security.rtkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Sound
  services.pipewire =
  { enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; };


  # services.xserver =
  # { enable = true;
  #   layout = "us";
  #   extraLayouts = {
  #     ThaiMnc = {
  #       description = "Thai Manoonchai Keyboard Layout";
  #       languages = ["tha"];
  #       symbolsFile = ./symbols/ThaiMnc;
  #     };
  #   };
  #   xkbOptions = "compose:ralt";};

  # # Kmonad
  # services.kmonad =
  # { enable = true;
  #   keyboards = {
  #     options = {
  #       name = "Kmonad-keyboard";
  #       device = "/dev/input/event19";
  #       defcfg = {
  #         enable = true;
  #         fallthrough = true;
  #         allowCommands = false;};
  #       config = ''

  #        (defsrc
  #         esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  #         grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  #         tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  #         caps a    s    d    f    g    h    j    k    l    ;    '    ret
  #         lsft z    x    c    v    b    n    m    ,    .    /    rsft up
  #         lctl lalt lmet           spc                 rmet ralt rctrl left down rght
  #        )

  #        (deflayer dvp
  #         _    _    _    _    _    _    _    _    _    _    _    _    _
  #         $    &    [    {    }    \(   =    *   \)    +    ]    !    #   bspc
  #         tab  ;    ,    .    p    y    f    g    c    r    l    /    @   \
  #         caps a    o    e    u    i    d    h    t    n    s    -    _
  #         lsft ,    q    j    k    x    b    m    w    v    z    _    _
  #         lctl lmet lalt           spc                 rmet    _    _    _   _  _
  #        )

  #       '';};};};
}
