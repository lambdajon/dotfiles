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

inputs.nixpkgs.lib.nixosSystem {
  system = arch;

  specialArgs = { inherit inputs pkgs-unstable; };

  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs pkgs-unstable; };
        sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
        backupFileExtension = "baka";
        home-manager.overwriteBackup = true;
      };
    }
  ]
  ++ modules;
}
