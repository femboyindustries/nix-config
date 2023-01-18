{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.gitea;
in {
  options.modules.services.gitea = {
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
  };

  config = mkIf cfg.enable {
    services = {
      gitea = {
        enable = true;
        package = pkgs.unstable.gitea;
        domain = cfg.domain;
        httpPort = cfg.port;
        rootUrl = "https://${cfg.domain}/";
        stateDir = "/var/lib/${cfg.domain}";
        appName = "Gitea: dark-firepit hosted Git";
        database = {
          type = "postgres";
          name = "gitea";
        };
        settings = mkMerge [ (builtins.fromTOML (builtins.readFile "/etc/dotfiles/config/gitea/app.toml")) {
          "ui.meta" = {
            AUTHOR = "aether & oat";
            DESCRIPTION = "dark-firepit's shared git instance";
          };
        }];
      };

      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        # using manual extraconfig because else    nginx spits out a runtime error????
        # thanks nginx
        #locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port};";
        locations."/".extraConfig = ''
          client_max_body_size 600M;
          proxy_pass http://127.0.0.1:${toString cfg.port};
        '';
      };
    };
  };
}
