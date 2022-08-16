{ config, lib, pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      vi = "emacsclient -nca emacs";};
    shellInit = ''
      set HOMECONF $HOME/nixos-config/home
      set ROOTCONF $HOME/nixos-config/root

      # TokyoNight Color Palette
      set -l foreground c0caf5
      set -l selection 33467C
      set -l comment 565f89
      set -l red f7768e
      set -l orange ff9e64
      set -l yellow e0af68
      set -l green 9ece6a
      set -l purple 9d7cd8
      set -l cyan 7dcfff
      set -l pink bb9af7

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
    '';
    functions = {
      fish_greeting = "";
      home-flake = "home-manager switch --flake $HOMECONF/#dash";
      root-flake = "sudo nixos-rebuild switch --flake $ROOTCONF/#";};
    plugins = [
      { name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";};}
      { name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "d4c107a2c99d1066950a09f605bffea61fc0efab";
          sha256 = "cQYT1EKlSev+FZe/zgeb3kzaqYOvZTJxFXbmwOk0UKo=";};}
    ];
  };
}
