{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    emacs.url = "github:nix-community/emacs-overlay";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

  };

  outputs = {
    nixpkgs,
    home-manager,
    sops-nix,
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
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          doom-emacs.hmModule
          spicetify-nix.homeManagerModule
          sops-nix.nixosModules.sops
        ];

      };
    };
}
