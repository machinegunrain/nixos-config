{ pkgs, ...}: {
 enable = true;
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
      rev = "cQYT1EKlSev+FZe/zgeb3kzaqYOvZTJxFXbmwOk0UKo=";
      sha256 = "";};}];
}
