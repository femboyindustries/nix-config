{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.metrics;
in {
  options.modules.services.metrics = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      # default = "grafana.oat.zone";
      default = null;
    };
    port = mkOption {
      type = types.int;
      default = 2342;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.domain != null;
        description = "please set the domain for grafana";
      }
    ];
    systemd.services.promtail = {
      description = "Promtail service for Loki";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yml}
        '';
      };
    };
    services = {
      grafana = {
        enable = true;

        settings = {
          server = {
            domain = cfg.domain;
            http_port = cfg.port;
            http_addr = "127.0.0.1";
          };
        };
      };

      prometheus = let
        ports = {
          base = 9001;
          node = 9002;
          nginx = 9003;
        };
      in {
        enable = true;
        port = ports.base;

        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" ];
            port = ports.node;
          };
          nginx = {
            enable = true;
            port = ports.nginx;
          };
        };

        scrapeConfigs = [
          {
            job_name = "lucent-firepit";
            static_configs = [{
              targets = [
                "127.0.0.1:${toString ports.node}"
                "127.0.0.1:${toString ports.nginx}"
              ];
            }];
          }
        ];
      };

      loki = {
        enable = true;
        configFile = ./loki-local-config.yml;
      };

      nginx.statusPage = true;

      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
        locations."= /robots.txt" = {
          extraConfig = ''
            add_header Content-Type text/plain;
            return 200 "User-agent: *\nDisallow: /\n";
          '';
        };
      };
    };
  };
}
