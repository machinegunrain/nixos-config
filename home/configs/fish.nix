{ pkgs, ...}: {
 enable = true;
 functions = {
   home-flake = "home-manager switch --flake .#dash";
 };
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
      sha256 = "cQYT1EKlSev+FZe/zgeb3kzaqYOvZTJxFXbmwOk0UKo=";};}];
}
