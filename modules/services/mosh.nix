{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.mosh;
in {
  options.modules.services.mosh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services = {
      mosh = {
        enable = true;
        # why is there not more config options???? oh well
      };
    };
  };
}
