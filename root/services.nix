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


  services.xserver = {
    layout = "us";
    xkbOptions = "compose:ralt";
  };

  # Kmonad
  services.kmonad = {
    enable = true;
        keyboards = {
      options = {
        name = "Kmonad-keyboard";
        device = "/dev/input/event19";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = ''
          (defalias
            dhp (around a (around b c))
          )

          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =  bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]
            caps a    s    d    f    g    h    j    k    l    ;    '    \  ret
            lsft z    x    c    v    b    n    m    ,    .    /           rsft
            lctl lmet lalt              spc                 ralt rmet cmp rctl
          )

          (deflayer dvp
            _  &    [    {    }   \(    =    *   \)    +    ]    !    #    _
            _  ;    ,    .    p    y    f    g    c    r    l    /    @
            _  a    o    e    u    i    d    h    t    n    s    -    _    _
            _  '    q    j    k    x    b    m    w    v    z              _
            _ _ _           _                                        _ _ _ _
          )
        '';
      };
    };
  };
}
