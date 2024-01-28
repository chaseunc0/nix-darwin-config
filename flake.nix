{
  description = "RadioAddition's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, unstable, ... }:
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#RadioAdditions-MacBook-Air
    darwinConfigurations = {
      "air2020" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./hosts/air2020.nix
        ];
      };
    };
    homeConfigurations = {
      "air2020" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {inherit inputs;};
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        modules = [
          ./home-manager/hosts/air2020.nix
        ];
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."RadioAdditions-MacBook-Air".pkgs;
  };
}
