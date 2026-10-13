# factory: { secretsFile, useSshKey, useHostKey }
{
  secretsFile,
  useSshKey ? false,
  useHostKey ? true,
}:
{ pkgs, lib, ... }:
{
  sops.defaultSopsFile = secretsFile;

  sops.age.sshKeyPaths =
    lib.optionals useHostKey [ "/etc/ssh/ssh_host_ed25519_key" ]
    ++ lib.optionals useSshKey [ "/root/.ssh/id_ed25519" ];

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
