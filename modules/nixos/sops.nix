# factory: { secretsFile, useSshKey }
{
  secretsFile,
  useSshKey ? true,
}:
{ pkgs, lib, ... }:
{
  sops.defaultSopsFile = secretsFile;
  sops.age.sshKeyPaths = lib.optionals useSshKey [ "~/.ssh/ed25519" ];

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
