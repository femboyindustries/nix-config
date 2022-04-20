{ lib, ... }:

let
  inherit (builtins) attrValues pathExists readDir;
  inherit (lib) filterAttrs hasSuffix mapAttrs' mkDefault mkOption
                nameValuePair nixosSystem removeSuffix types;
  inherit (lib._) mapFilterAttrs attrValuesRec;
in rec {
  mapModules' = dir: fn: dirfn:
    mapFilterAttrs
      (_: v: v != null)
      (name: type:
        let
          path = "${toString dir}/${name}";
        in
          if type == "directory" then
            nameValuePair name (dirfn path)
          else if type == "regular" && name != "default.nix" && hasSuffix ".nix" name then
#          else if type == "regular" && hasSuffix ".nix" name then
            nameValuePair (removeSuffix ".nix" name) (fn path)
          else
            nameValuePair "" null
      )
      (readDir dir);

  mapModules = dir: fn: mapModules' dir fn (path: if pathExists "${path}/default.nix" then (fn path) else null);
  mapModulesRec = dir: fn: mapModules' dir fn (path: mapModulesRec path fn);
  mapModulesRec' = dir: fn: attrValuesRec (mapModulesRec dir fn);
}
