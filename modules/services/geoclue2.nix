{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.geoclue2;
in {
  options.modules.services.geoclue2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.geoclue2.enable = true;
  };
}
