# factory: { name, email, signing, extraConfig }
{
  name,
  email,
  signing ? null, # set to a GPG key fingerprint to enable commit signing
  extraConfig ? { },
}:
{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;

    signing =
      if signing != null then
        {
          key = signing;
          signByDefault = true;
        }
      else
        { };

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
    };

    aliases = {
      st = "status -sb";
      co = "checkout";
      lg = "log --oneline --graph --decorate";
      push-new = "!git push --set-upstream origin $(git branch --show-current)";
    };

    ignores = [
      ".idea"
      ".DS_Store"
      "nohup.out"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      # rebase.autoStash = true;
      # merge.conflictstyle = "diff3";
    }
    // extraConfig;
  };

  home.packages = with pkgs; [
    gh
    git-lfs
  ];
}
