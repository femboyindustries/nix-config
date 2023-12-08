{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.vaultwarden;
in {
  options.modules.services.vaultwarden = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    domain = mkOption {
      type = types.str;
      default = null;
    };

    port = mkOption {
      type = types.port;
      default = 8222;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.domain != null;
        description = "Vaultwarden requires a domain to be defined";
      }
    ];

    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        config = {
          DOMAIN = "https://${cfg.domain}";
          DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
          DATA_FOLDER = "/var/lib/bitwarden_rs";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;
          ROCKET_LOG = "critical";
        };
        environmentFile = "${config.services.vaultwarden.config.DATA_FOLDER}/conf.env";
      };

      nginx.virtualHosts.${cfg.domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };

      postgresql = {
        enable = true;
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [
          { name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };
    };
  };
}
