{ lib, pkgs, config, ... }:

with lib;
let
  peerKeys = import ./authorizedKeys.nix lib;
  wgKeys = filter (hasAttr "wg") peerKeys.list;
in {
  ips = [ "10.100.0.1/24" ];

  privateKeyFile = "/etc/wg0.keys/wg0";

  listenPort = 51820;

  peers = genList (n: let
    keychain = elemAt wgKeys n;
    ip = "10.100.0.${toString (n+2)}/32";
  in {
    publicKey = trace "${keychain.hostname}: ${ip}" keychain.wg;
    allowedIPs = [ ip ];
  }) (length wgKeys);
}

