{ lib, ... }:

let
  inherit (builtins) attrValues readDir pathExists;
  inherit (lib) id filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix mapAttrs' trace fix fold isAttrs;
in rec {
  mapModules' = dir: fn: dirfn:
    filterAttrs
      (name: type: type != null && !(hasPrefix "_" name))
      (mapAttrs'
        (name: type:
          let path = "${toString dir}/${name}"; in
          if type == "directory"
          then nameValuePair name (dirfn path)
          else if
            type == "regular" &&
            name != "default.nix" &&
            hasSuffix ".nix" name
          then nameValuePair (removeSuffix ".nix" name) (fn path)
          else nameValuePair "" null
        )
        (readDir dir));

  mapModules = dir: fn: mapModules' dir fn (path: if pathExists "${path}/default.nix" then fn path else null);
  mapModulesRec = dir: fn: mapModules' dir fn (path: mapModulesRec path fn);
  mapModulesRec' = dir: fn: fix (f: attrs: fold (x: xs: (if isAttrs x then f x else [x]) ++ xs) [] (attrValues attrs)) (mapModulesRec dir fn);
}
