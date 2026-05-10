# factory: { defaultEditor }
# Note: extraPackages (LSP servers) are set at the host level alongside
# devtools selections — this module only configures the editor itself.
{
  defaultEditor ? false,
}:
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    inherit defaultEditor;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
  };

  home.sessionVariables =
    if defaultEditor then
      {
        EDITOR = "nvim";
        VISUAL = "nvim";
      }
    else
      { };
}
