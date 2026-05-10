{ ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = builtins.concatStringsSep "" [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      character = {
        success_symbol = "[λ](bold purple)";
        error_symbol = "[λ](bold red)";
      };

      directory = {
        truncation_length = 4;
        style = "bold cyan";
      };

      git_branch.symbol = " ";

      nix_shell = {
        symbol = " ";
        style = "bold blue";
        format = "[$symbol$name]($style) ";
      };
    };
  };
}
