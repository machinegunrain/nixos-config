{ config, pkgs, lib, ... }:
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
  
    configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configue-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsetting-schemas/${schema.name}";
      in ''
         export XDG_DATA_DIR=${datadir}:$XDG_DATA_DIRS
         gnome_schema=org.gnom.desktop.interface
         gsettings set $gnome_schema gtk-theme 'Dracular
      '';
  };
  
  swayEnv = [ dbus-sway-environment configure-gtk ];
  modifier = config.wayland.windowManager.sway.config.modifier;
in {

  home = {
  username = "dash";
  homeDirectory = "/home/dash";
  stateVersion  = "22.05";
  keyboard = null;

  };

  home.packages = with pkgs; [
    htop gnumake glib unzip i2c-tools
    wayland swaylock swayidle waybar 
    mpv spotify
    wofi mako
    wl-clipboard
    texlive.combined.scheme-full
  ] ++ swayEnv;

  programs.home-manager.enable = true;
  programs.fish.enable = true;
  
  programs.vscode = {
    enable=true;
    package = pkgs.vscodium;};

  programs.java = {
    enable = true;
    package = pkgs.jdk11;};

  programs.foot = {
    enable = true;
      settings = {
      main = {
      term = "xterm-256color";
      font = "PragmataPro Mono Liga:size=12";
      dpi-aware = "yes";
      };
      mouse = {
      hide-when-typing = true;
      };
      colors = {
      foreground="d9e0ee";
background="1e1e2e";
selection-foreground="1e1e2e";
selection-background="d9e0ee";
regular0="6e6c7e";  # black
regular1="f28fad";  # red
regular2="abe9b3";  # green
regular3="fae3b0";  # yellow
regular4="96cdfb";  # blue
regular5="f5c2e7";  # magenta
regular6="89dceb";  # cyan
regular7="d9e0ee";  # white
bright0="988ba2";   # bright black
bright1="f28fad";   # bright red
bright2="abe93b";   # bright green
bright3="fae3b0";   # bright yellow
bright4="96cdfb";   # bright blue
bright5="f5c2e7";   # bright magenta
bright6="89dceb";   # bright cyan
bright7="d9e0ee";   # bright white
      };
      };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "foot";
      menu = "wofi --show run";
      bars = [{
        fonts.size = 12.0;
        command = "waybar";
        position = "top";
      }];
      input."type:keyboard" = {
      xkb_layout = "us";
      xkb_variant = "dvp";
      xkb_options = "grp:alt_win_toggle";
      };
      output = {
       DVI1 = { pos = "0 0"; res = "1920x1080";};
      };
      fonts = {
        names = ["Iosevka"];
	size = 12.0;
      };
keybindings =  {
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
"${modifier}+Shift+Left" = "move left";
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
"${modifier}+d" = "exec wofi --show run";
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
"${modifier}+w" = "layout tabbed";
};
    };
  };
}
