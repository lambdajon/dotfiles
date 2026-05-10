{ lib }:

{
  mkNixosHost = import ./mkNixosHost.nix { inherit lib; };
  mkDarwinHost = import ./mkDarwinHost.nix { inherit lib; };
}
