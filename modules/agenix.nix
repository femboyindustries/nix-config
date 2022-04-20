{ options, lib, inputs, pkgs, config, ... }:

with builtins;
with lib;
with lib._;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets = mkMerge (map (x: {"x".file = "${secretsDir}/${x}";}) (attrNames (import secretsFile)));
    identityPaths = options.age.identityPaths.default ++ (foldr (l: r: l ++ r) [] (map (user:
      let
        d = "/home/${user}/.ssh";
        fs = map (f: d + "/" + f)
          (filter (f: (f != "known_hosts") && (f != "*.old"))
            (attrNames (readDir d)));
      in fs) (attrNames config.defaultUsers)));
  };
}
