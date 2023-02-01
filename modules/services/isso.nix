{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.isso;
in {
  options.modules.services.isso = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "comments.oat.zone";
    };
    target = mkOption {
      type = types.str;
      default = "blog.oat.zone";
    };
    port = mkOption {
      type = types.port;
      default = 1550;
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/isso";
    };
  };

  config = mkIf cfg.enable {
    services = {
      isso = {
        enable = true;
        settings = {
          general = {
            dbpath = "${cfg.dataDir}/comments.db";
            host = "https://${cfg.target}";
            latest-enabled = true;
          };
          server = {
            listen = "http://localhost:${toString cfg.port}";
            samesite = "Lax";
            public-endpoint = "https://${cfg.domain}";
          };
          guard = {
            enabled = true;
            require-author = true;
            ratelimit = 4;
          };
          admin = {
            enabled = true;
            password = removeSuffix "\n" (builtins.readFile /etc/isso_admin_pass);
          };
        };
      };

      nginx.enable = true;
      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    systemd.services.isso.serviceConfig = {
      preStart = ''
        umask u=rwx,g=rwx,o=rx
        mkdir -p ${cfg.dataDir}
        cd ${cfg.dataDir}
        ${pkgs.coreutils}/bin/chown -R isso:isso .
        ${pkgs.coreutils}/bin/chmod -R 775 .
      '';
    };
  };
}
