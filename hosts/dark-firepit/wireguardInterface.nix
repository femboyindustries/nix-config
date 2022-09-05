{ lib, pkgs, config, ... }:

with lib;
let
  peerKeys = import ./authorizedKeys.nix;
in {
  ips = [ "10.100.0.1/24" ];

  privateKeyFile = "/etc/wg0.keys/wg0";

  listenPort = 51820;

  peers = genList (n: {
    publicKey = (elemAt (attrValues peerKeys) n).wg;
    allowedIPs = [ "10.100.0.${toString (n+2)}/32" ];
  }) (length (attrValues peerKeys));
}

