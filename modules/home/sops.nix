# direct module — sets up the age key from the user's SSH key.
# Declare secrets and secretsFile directly in the host:
#   sops.defaultSopsFile = ../../secrets/users/lambdajon.yaml;
#   sops.secrets.github_token = {};
{ config, ... }:
{
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
