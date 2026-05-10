{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      ".." = "cd ..";
      "..." = "cd ../..";
      g = "git";
      nb = "nix build";
      nd = "nix develop";
      nfu = "nix flake update";
      ns = "nix shell";
    };

    initExtra = ''
      if command -v eza &>/dev/null; then
        alias ls='eza --icons'
        alias ll='eza -la --icons --git'
        alias tree='eza --tree --icons'
      fi
      if command -v zoxide &>/dev/null; then
        eval "$(zoxide init zsh)"
      fi
    '';
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    eza
    bat
    fd
    fzf
    ripgrep
    zoxide
  ];
}
