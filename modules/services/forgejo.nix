{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.forgejo;
in {
  options.modules.services.forgejo = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "git.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 3000;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.unstable.forgejo;
    };
    enableActions = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = cfg.enableActions;
  
    services = {
      forgejo = {
        enable = true;
        package = cfg.package;
        stateDir = "/var/lib/${cfg.domain}";
        database = {
          type = "postgres";
          # leaving this blank intentionally
        };
        settings = mkMerge [ (builtins.fromTOML (builtins.readFile "/etc/dotfiles/config/forgejo/app.toml")) {
          "ui.meta" = {
            AUTHOR = "dark-firepit.cloud";
            DESCRIPTION = "dark-firepit's shared git instance";
          };
          "server" = {
            DOMAIN = cfg.domain;
            HTTP_PORT = cfg.port;
            ROOT_URL = "https://${cfg.domain}/";
          };
          "actions" = {
            ENABLED = cfg.enableActions;
          };
        }];
      };

      # todo: why is this failing?
      gitea-actions-runner = mkIf cfg.enableActions {
        instances."${config.networking.hostName}" = {
          enable = true;
          name = "ci";
          url = "https://${cfg.domain}/";
          labels = []; # use the packaged instance list
          token = removeSuffix "\n" (builtins.readFile "/etc/forgejo-runner-token");
        };
      };

      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            client_max_body_size 600M;
          '';
        };
      };
    };
  };
}
