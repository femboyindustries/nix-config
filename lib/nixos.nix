{ inputs, lib, pkgs, ... }:

with lib;
{
  mkHost = path: attrs@{ system, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)

        ../.

        (import path)
      ];
    };
}
