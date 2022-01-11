{ config, pkgs, lib, options, ... }:

with lib;
let
  cfg = config.modules.dev.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    version = mkOption {
      type = types.str;
      default = "ghc8107";
    };
    packages = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.haskell.packages."${cfg.version}"; [
      ghc
      cabal-install
    ] ++ config.modules.dev.haskell.packages;
  };
}
