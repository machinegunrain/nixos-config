{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.workspace = nixpkgs.lib.nixosSystem {
      system = "x86-64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
