# devtools.nix — package catalog for all dev stacks
#
# This is pure data. No modules, no options, no enable flags.
# Each host imports this file and selects exactly what it needs with ++.
#
# Rule: only universal toolchain packages belong here.
# Optional tools (pkgs.stack, cabal-hoogle, etc.) are added at the host
# level with ++. No withPackages, no extraPackages, no custom derivations.

{
  pkgs,
  pkgs-unstable,
  lib,
}:

let
  hpkgs = pkgs.haskell.packages.ghc910;
in
{

  haskell = {
    core = [
      hpkgs.ghc
      hpkgs.cabal-install
      hpkgs.haskell-language-server
      hpkgs.fourmolu
      hpkgs.hlint
    ];

    vscode.extensions = with pkgs.vscode-extensions; [
      haskell.haskell
      justusadam.language-haskell
    ];
    vscode.userSettings = {
      haskell.formattingProvider = "fourmolu";
      haskell.manageHLS = "PATH";
      "files.associations"."*.hs" = "haskell";
      "files.associations"."*.dump-simpl" = "haskell";
    };
    neovim.packages = [ hpkgs.haskell-language-server ];
  };

  rust = {
    core = with pkgs; [
      rust-analyzer
      cargo-watch
      cargo-edit
      cargo-nextest
      mold
    ];

    vscode.extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
    vscode.userSettings = { };
    neovim.packages = [ ];
  };

  js = {
    core = with pkgs; [
      typescript
      typescript-language-server
      prettier
      eslint
    ];
    node = [ pkgs.nodejs ];
    deno = [ pkgs.deno ];

    vscode.extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss
    ];
    vscode.userSettings = {
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    neovim.packages = with pkgs; [
      typescript-language-server
      prettier
      eslint
    ];
  };

}
