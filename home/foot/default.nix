{config, lib, pkgs, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = { term = "xterm-256color";
               font = "PragmataPro Mono Liga:size=12";
               dpi-aware = "yes";};
      mouse = { hide-when-typing = true;};
      colors = {
        background="1a1b26";
        foreground="c0caf5";
        regular0="15161E";
        regular1="f7768e";
        regular2="9ece6a";
        regular3="e0af68";
        regular4="7aa2f7";
        regular5="bb9af7";
        regular6="7dcfff";
        regular7="a9b1d6";
        bright0="414868";
        bright1="f7768e";
        bright2="9ece6a";
        bright3="e0af68";
        bright4="7aa2f7";
        bright5="bb9af7";
        bright6="7dcfff";
        bright7="c0caf5";
      };
    };
  };
}