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
    port = mkOption {
      type = types.port;
      default = 1550;
    };
  };

  config = mkIf cfg.enable {
    services = {
      isso = {
        enable = true;
        settings = {
          general = {
            host = "https://blog.oat.zone/";
            latest-enabled = true;
          };
          server = {
            listen = "http://localhost:${toString cfg.port}";
            samesite = "Lax";
            public-endpoint = "https://comments.oat.zone";
          };
          guard = {
            enabled = true;
            require-author = true;
            ratelimit = 4;
          };
          admin = {
            enabled = true;
            password = "a8UYAH7jQQC3LjnG";
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
  };
}
