{ inputs, lib, pkgs, ... }:

lib.extend (self: super:
  let
    inherit (lib) attrValues foldr;
    inherit (modules) mapModules;
    inherit (helpers) getSSH;

    modules = import ./modules.nix { inherit lib; };
    helpers = import ./helpers.nix { inherit lib; };
  in {
    _ = foldr (a: b: a // b) {} (attrValues (mapModules ./. (file: import file {
      inherit pkgs inputs;
      lib = self;
    })));
  }
)
