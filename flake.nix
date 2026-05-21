{
  description = "Lambdajon's dotfiles — composable, host-configurable";

  inputs = {
    # Stable nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Unstable for bleeding-edge packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS support
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland (wayland WM)
    hyprland.url = "github:hyprwm/Hyprland";

    relago.url = "git+https://git.oss.uzinfocom.uz/xinux/relago";

    # Zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      # home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      sops-nix,
      disko,
      hyprland,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      mkLib = import ./lib { inherit lib; };
      personal = import ./personal.nix;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forEachSystem = lib.genAttrs systems;

      mkNixos =
        host: arch:
        mkLib.mkNixosHost {
          inherit inputs host arch;
          modules = [
            ./hosts/${host}
            { _module.args.personal = personal; }
          ];
        };

    in
    {
      # NixOS machines
      nixosConfigurations = {
        victus = mkNixos "victus" "x86_64-linux";
      };

      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "Welcome to dotfiles";
            packages = with pkgs; [
              sops
              age
              ssh-to-age

              nixfmt-rfc-style
              deadnix
              statix
              nix-tree
              nil

              git
              just
            ];
          };
        }
      );
    };
}
