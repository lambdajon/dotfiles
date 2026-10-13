# openQA single-instance (web UI + worker) running in podman
# Web UI: http://localhost:1080
{ ... }:
{
  virtualisation.podman.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers.openqa = {
      image = "registry.opensuse.org/devel/openqa/containers/openqa-single-instance:latest";
      autoStart = true;
      ports = [
        "127.0.0.1:1080:80"
        "127.0.0.1:1443:443"
      ];
      volumes = [
        "/var/lib/openqa/share:/var/lib/openqa/share"
        "/var/lib/openqa/pgsql:/var/lib/pgsql"
      ];
      extraOptions = [
        "--device=/dev/kvm"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/openqa 0755 root root -"
    "d /var/lib/openqa/share 0755 root root -"
    "d /var/lib/openqa/pgsql 0755 root root -"
  ];
}
