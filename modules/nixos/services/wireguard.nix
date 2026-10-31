{ hostId }:
{ pkgs, ... }:
let
  interface = "wg-work";
  subnet4 = address: "10.66.66.${toString address}/32";
  subnet6 = address: "fd00:fae:fae:fae:fae:${toString address}::/96";
  peer = name: address: endpoint: publicKey: {
    inherit endpoint publicKey;
    allowedIPs = [
      (subnet4 address)
      (subnet6 address)
    ];
    persistentKeepalive = 25;
  };
in
{
  networking.wg-quick.interfaces.${interface} = {
    privateKeyFile = "/var/lib/wireguard/${interface}.key";
    generatePrivateKeyFile = true;
    address = [
      (subnet4 hostId)
      (subnet6 hostId)
    ];
    peers = [
      (peer "bare-metal-ns1" 1 "91.212.89.25:51820" "h+Lj7eQ4yX72HXB954aZ19+Ug9DF8WiHijxwKbjYaik=")
      (peer "bare-metal-ns2" 2 "91.212.89.28:51820" "ZGnqqVHt5k7t+hEmjzc9vU22QXTalBjnAPjDI5QcvQo=")
      (peer "virtual-machine-ns1" 101 "185.8.213.158:51820" "+OT0mopHJ32EB4bfNC1ZBDXB0uL90IlpIErwPzLop3E=")
      (peer "virtual-machine-ns2" 102 "185.8.213.159:51820" "UHDVJzqMwpZ2tRwCh2c8FqgYrCNSrtd6VxO0duj4ew4=")
    ];
  };

  networking.networkmanager.unmanaged = [ interface ];

  environment.systemPackages = [ pkgs.wireguard-tools ];
}
