{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.nodejs;
in {
  options.modules.dev.nodejs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    packages = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
    };
  };
}
