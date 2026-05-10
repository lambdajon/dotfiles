{ lib }:

{
  inputs,
  host,
  arch,
  modules ? [ ],
}:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = arch;
    config.allowUnfree = true;
  };
in

inputs.nix-darwin.lib.darwinSystem {
  system = arch;

  specialArgs = { inherit inputs pkgs-unstable; };

  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs pkgs-unstable; };
        sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      };
    }
  ]
  ++ modules;
}
