{ lib, pkgs, config, ... }:

with lib;
let
  peerKeys = import ../authorizedKeys.nix;
in {
  ips = [ "10.100.0.1/24" ];

  privateKeyFile = readFile "/etc/wg0.keys/wg0";

  listenPort = 51820;

  peers = genList (n: {
    publicKey = elemAt (attrValues peerKeys) n;
    allowedIPs = [ "10.100.0.${n+2}/32" ];
  }) (length (attrValues peerKeys));
}
