# direct module — base editor config only
# Stack-specific extensions and settings are applied at the host level
# via devtools selections (D.*.vscode.*).
{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;

    extensions =
      with pkgs.vscode-extensions;
      [
        # vscodevim.vim
        jnoortheen.nix-ide
        eamodio.gitlens
        pkief.material-icon-theme
        mechatroner.rainbow-csv

        pkief.material-product-icons
        donjayamanne.githistory
        jdinhlife.gruvbox

        # mads-hartmann.bash-ide-vscode
        tamasfe.even-better-toml

        eamodio.gitlens
        usernamehw.errorlens
        oderwat.indent-rainbow
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "language-x86-64-assembly";
          publisher = "13xforever";
          version = "3.1.5";
          sha256 = "sha256-WIhmAZLR2WOSqQF3ozJ/Vr3Rp6HdSK7L23T3h4AVaGM=";
        }
      ];

    userSettings = {
      editor = {
        tabSize = 2;
        # formatOnSave = true;
        # fontFamily   = "'JetBrainsMono Nerd Font', monospace";
        # fontSize = 14;
        # lineNumbers  = "relative";
      };
      files.autoSave = "afterDelay";
      workbench = {
        colorTheme = "Gruvbox Dark Medium";
        iconTheme = "material-icon-theme";
        productIconTheme = "material-product-icons";
      };
      chat = {
        disableAIFeatures = true;
        agent.enabled = false;
        commandCenter.enabled = false;
      };
      "inlineChat.accessibleDiffView" = "off";
      "extensions.autoCheckUpdates" = false;
      "window.nativeTabs" = true;

      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "[jsonc]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
    };
  };
}
