{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.matomo;
in {
  options.modules.services.matomo = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "analytics.oat.zone";
    };
  };

  config = mkIf cfg.enable {
    services = {
      matomo = {
        enable = true;

        package = pkgs.unstable.matomo-beta;
        periodicArchiveProcessing = true;
        hostname = cfg.domain;
        nginx = {
          serverAliases = [
            cfg.domain
          ];
          enableACME = true;
        };
      };

      mysql = {
        enable = true;

        package = pkgs.unstable.mariadb;

        settings = {
          mysqld = {
            max_allowed_packet = "128M";
          };
          client = {
            max_allowed_packet = "128M";
          };
        };

        ensureDatabases = [ "matomo" ];
        ensureUsers = [
          {
            name = "matomo";
            ensurePermissions = {
              "matomo.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };
    };
  };
}
