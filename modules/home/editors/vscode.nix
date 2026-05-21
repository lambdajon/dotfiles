# direct module — base editor config only
# Stack-specific extensions and settings are applied at the host level
# via devtools selections (D.*.vscode.*).
{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
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

    ];

    userSettings = {
      editor = {
        tabSize = 2;
        # formatOnSave = true;
        # fontFamily   = "'JetBrainsMono Nerd Font', monospace";
        # fontSize = 14;
        # lineNumbers  = "relative";
      };
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
    };
  };
}
