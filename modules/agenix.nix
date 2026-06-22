{ options, lib, inputs, pkgs, config, ... }:

with builtins;
with lib;
with lib._;
let
  inherit (inputs) agenix;
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.default ];

/*
  age = let
    # ugly, lazy, but works
    users = map (user: "/home/${user}/.ssh") (attrNames (readDir "/home/"));

    usersWithKeys = filter (path: pathExists path) users;

    userIdentityPaths = concatLists (map (keysPath:
      let
        # find all files that are id_* and not *.pub
        # todo: maybe make a startsWith / endsWith?
        files = map (f: keysPath + "/" + f)
          (filter (f: (substring 0 3 f == "id_") && (substring (stringLength f - 4) 4 f != ".pub"))
            (attrNames (readDir keysPath)));
      in files) usersWithKeys);
  in {
    secrets = mkMerge (map (x: {"${x}".file = "${secretsDir}/${x}";}) (attrNames (import secretsFile)));
    identityPaths = options.age.identityPaths.default ++ userIdentityPaths;
  };
  */
}
