{config, lib, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
  name = "dbus-sway-environment";
  destination = "/bin/dbus-sway-enviroment";
  executable = true;
  text = ''
     dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
     systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
     systemctl --uses start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
     '';
  };
  modifier = config.wayland.windowManager.sway.config.modifier;

in
{ home.packages = with pkgs; [ wayland dbus-sway-environment swaylock swayidle wl-clipboard ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      window.border = 0;
      terminal = "footclient";
      menu = "rofi -show drun";
      bars = [{
        fonts.size = 12.0;
        command = "waybar";
        position = "top"; }];
      input."type:keyboard" = {
        xkb_layout = "us,ThaiMnc";
        xkb_variant ="dvp,";
        xkb_options = "grp:ctrl_shift_toggle"; };
      output = { DVI1 = { pos = "0 0"; res = "1920x1080";};};
      fonts = { names = ["PragmataPro Mono Liga"]; size = 12.0;};
      keybindings = {
        "${modifier}+ampersand" = "workspace number 1";
        "${modifier}+bracketleft" = "workspace number 2";
        "${modifier}+braceleft" = "workspace number 3";
        "${modifier}+braceright" = "workspace number 4";
        "${modifier}+parenleft" = "workspace number 5";
        "${modifier}+equal" = "workspace number 6";
        "${modifier}+asterisk" = "workspace number 7";
        "${modifier}+parenright" = "workspace number 8";
        "${modifier}+plus" = "workspace number 9";
        "${modifier}+Down" = "focus down";
        "${modifier}+Left" = "focus left";
        "${modifier}+Return" = "exec foot";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+ampersand" = "move container to workspace number 1";
        "${modifier}+Shift+bracketleft" = "move container to workspace number 2";
        "${modifier}+Shift+braceleft" = "move container to workspace number 3";
        "${modifier}+Shift+braceright" = "move container to workspace number 4";
        "${modifier}+Shift+parenleft" = "move container to workspace number 5";
        "${modifier}+Shift+equal" = "move container to workspace number 6";
        "${modifier}+Shift+asterisk" = "move container to workspace number 7";
        "${modifier}+Shift+parenright" = "move container to workspace number 8";
        "${modifier}+Shift+plus" = "move container to workspace number 9";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Left" ="move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Up" = "focus up";
        "${modifier}+a" = "focus parent";
        "${modifier}+b" = "splith";
        "${modifier}+d" = "exec rofi -show drun";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+minus" = "scratchpad show";
        "${modifier}+r" = "mode resize";
        "${modifier}+s" = "layout stacking";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+v" = "splitv";
        "${modifier}+w" = "layout tabbed"; };
    };
  };
}
