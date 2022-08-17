{ config, lib, pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      neofetch = "neofetch --ascii ~/nixos_config/home/fish/nixos.ascii --ascii_colors 6 3";
    };
    shellAbbrs = {
      vi = "emacsclient -nca emacs";};
    shellInit = ''
      set HOMECONF $HOME/nixos-config/home
      set ROOTCONF $HOME/nixos-config/root

      # Colorscheme: Nord
      set -U fish_color_normal normal
      set -U fish_color_command 81a1c1
      set -U fish_color_quote a3be8c
      set -U fish_color_redirection b48ead
      set -U fish_color_end 88c0d0
      set -U fish_color_error ebcb8b
      set -U fish_color_param eceff4
      set -U fish_color_comment 434c5e
      set -U fish_color_match --background=brblue
      set -U fish_color_selection white --bold --background=brblack
      set -U fish_color_search_match bryellow --background=brblack
      set -U fish_color_history_current --bold
      set -U fish_color_operator 00a6b2
      set -U fish_color_escape 00a6b2
      set -U fish_color_cwd green
      set -U fish_color_cwd_root red
      set -U fish_color_valid_path --underline
      set -U fish_color_autosuggestion 4c566a
      set -U fish_color_user brgreen
      set -U fish_color_host normal
      set -U fish_color_cancel --reverse
      set -U fish_pager_color_prefix normal --bold --underline
      set -U fish_pager_color_progress brwhite --background=cyan
      set -U fish_pager_color_completion normal
      set -U fish_pager_color_description B3A06D
      set -U fish_pager_color_selected_background --background=brblack
      set -U fish_pager_color_selected_completion
      set -U fish_pager_color_secondary_background
      set -U fish_pager_color_secondary_description
      set -U fish_color_option
      set -U fish_pager_color_secondary_completion
      set -U fish_color_host_remote
      set -U fish_pager_color_background
      set -U fish_pager_color_selected_prefix
      set -U fish_color_keyword
      set -U fish_pager_color_secondary_prefix
      set -U fish_pager_color_selected_description

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
