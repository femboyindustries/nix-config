{ pkgs, config, lib, options, ... }:

with lib;
let
  cfg = config.modules.services.nextcloud;
in {
  options.modules.services.nextcloud = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nextcloud27;
    };

    domain = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable (trace "the balls" {
    assertions = [
      { assertion = cfg.domain != null;
        description = "Nextcloud requires a domain.";
      }
    ];

    # vomit inducing
    # nixpkgs.config.permittedInsecurePackages = [
    #   "openssl-1.1.1w"
    # ];

    services.nextcloud = {
      enable = true;
      package = cfg.package;
      hostName = cfg.domain;
      enableBrokenCiphersForSSE = false;
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        adminpassFile = "/etc/nextcloudpass";
        adminuser = "root";
#        "log_type" = "systemd";
#        "syslog_tag" = "Nextcloud";
#        loglevel = "3";
      };
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."^~ /.well-known" = {};
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        { name = "nextcloud";
          ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }
      ];
    };

    systemd.services."nextcloud-setup" = {
      requires = ["postgresql.service"];
      after = ["postgresql.service"];
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  });
}
