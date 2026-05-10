# factory: { defaultEditor, package, extraPackages }
{
  defaultEditor ? false,
  package ? null,
  extraPackages ? _: [ ],
}:
{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = if package != null then package else pkgs.emacs29-pgtk;
    extraPackages = extraPackages;
  };

  services.emacs = {
    enable = true;
    defaultEditor = defaultEditor;
  };

  home.sessionVariables =
    if defaultEditor then
      {
        EDITOR = "emacsclient -t";
        VISUAL = "emacsclient -c";
      }
    else
      { };
}
