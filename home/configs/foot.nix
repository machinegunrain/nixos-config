{ pkgs, ... }: {
  enable = true;
    settings = {
    main = { term = "xterm-256color";
             font = "PragmataPro Mono Liga:size=12";
             dpi-aware = "yes";};
    mouse = { hide-when-typing = true;};
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
}
