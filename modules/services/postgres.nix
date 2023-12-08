{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.postgres;
in {
  options.modules.services.postgres = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
    };
  };
}
