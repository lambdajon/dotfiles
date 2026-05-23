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

      ssh-hosts = "grep -P \"^Host ([^*]+)$\" $HOME/.ssh/config | sed 's/Host //'";
      refresh = "source ~/.zshrc";
      ports = "sudo lsof -PiTCP -sTCP:LISTEN";
      nix-shell = "nix-shell --run zsh";
      nix-develop = "nix develop -c \"$SHELL\"";
      dockfm = "docker ps --all --format \"NAME:   {{.Names}}\nSTATUS: {{.Status}}\nPORTS:  {{.Ports}}\n\"";
      clean = "nix store gc && nix-collect-garbage -d"; # FIXME: not supported in macos
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

    initContent = ''
      # Global settings
      setopt AUTO_CD
      setopt BEEP
      setopt HIST_BEEP
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY
      setopt INC_APPEND_HISTORY
      setopt INTERACTIVE_COMMENTS
      setopt MAGIC_EQUAL_SUBST
      setopt NO_NO_MATCH
      setopt NOTIFY
      setopt NUMERIC_GLOB_SORT
      setopt PROMPT_SUBST
      setopt SHARE_HISTORY

    '';
  };

  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    eza
    bat
    fd
    fzf
    ripgrep
    zoxide
  ];
}
