{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.libreddit;
in {
  options.modules.services.libreddit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "libreddit.oat.zone";
    };
    port = mkOption {
      type = types.port;
      default = 1590;
    };
  };

  config = mkIf cfg.enable {
    services = {
      libreddit = {
        enable = true;
        package = pkgs.libreddit;
        port = cfg.port;
      };

      nginx.enable = true;
      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          extraConfig = ''
            if ($http_user_agent = 'Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)') {
              return 302 $scheme://proxy.knotty.dev$request_uri;
            }
          '';
        };
      };
    };
  };
}
