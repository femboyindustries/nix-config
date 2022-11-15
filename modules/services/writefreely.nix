{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.writefreely;
in {
  options.modules.services.writefreely = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.writefreely;
    };

    user = mkOption {
      type = types.str;
      default = "writefreely";
    };
  };

  config = mkIf cfg.enable {
  };
}
