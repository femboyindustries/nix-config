{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.dark-firepit-oat-zone;
in {
  options.modules.services.dark-firepit-oat-zone = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "dark-firepit.oat.zone";
    };
  };

  config = mkIf cfg.enable {
    services = {
      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/dark-firepit.oat.zone";
      };
    };
  };
}
