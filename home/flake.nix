{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs.url = "github:nix-community/emacs-overlay";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

  };

  outputs = {
    nixpkgs,
    home-manager,
    emacs,
    doom-emacs,
    spicetify-nix,
    ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true;};
      };
    in {
      nixpkgs.overlays = [ (import emacs) ];
      homeConfigurations.dash = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/base
          ./modules/dash.nix
          doom-emacs.hmModule
          spicetify-nix.homeManagerModule
        ];

      };
    };
}
