{ options, lib, inputs, pkgs, config, ... }:

with builtins;
with lib;
with lib._;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
/*
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets = mkIf (pathExists secretsFile) (mapAttrs (n: o: {
      file = "${secretsDir}/" + n;
      owner = o.owner;
    }) (import secretsFile));
    identityPaths = options.age.identityPaths.default ++ (filter pathExists [
#      ".ssh/id_ed25519"
#      ".ssh/id_rsa"
    ]);
  };
*/
}
