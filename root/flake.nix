{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    kmonad.url = "github:kmonad/kmonad?dir=nix";

  };

  outputs = { self, nixpkgs, kmonad, ... }@attrs: {
    nixosConfigurations.workspace = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        kmonad.nixosModules.default
      ];
    };
  };
}
