{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.akkoma;

  configScriptPost = pkgs.writeShellApplication {
    text = ''
    echo Running configScriptPost
    cd "$RUNTIME_DIRECTORY"
    echo "# configScriptPost patches:" >> config.exs
    echo "config :pleroma, configurable_from_database: true" >> config.exs
    echo Done patching the config!
    '';
    name = "configScriptPost";
  } + "/bin/configScriptPost";
in {
  options.modules.services.akkoma = {
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
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.domain != null;
        description = "Akkoma domain left undefined";
      }

      { assertion = cfg.domain != null;
        description = "Akkoma port left undefined";
      }
    ];

    services.akkoma = {
      enable = true;
      nginx.enableACME = true;
      nginx.forceSSL = true;
      dist.epmdPort = cfg.port;
      config.":pleroma" = {      
        ":instance" = {
          name = "Website League (Dark-Firepit Edition)";
          description = "website league but dark-firepit edition";
          email = "aethera@protonmail.com";
          registration_open = false;
        };

        "Pleroma.Web.Endpoint" = {
          url.host = cfg.domain;
        };
      };
      frontends.primary = {
        package = pkgs._.mangane;
        name = "mangene";
        ref = "static";
      };
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      locations."/" = {
        extraConfig = ''
          # add style-src for mangane
          proxy_hide_header Content-Security-Policy;
          add_header Content-Security-Policy "upgrade-insecure-requests;script-src 'self';connect-src 'self' blob: https://example.com wss://example.com;media-src 'self' https:;img-src 'self' data: blob: https:;default-src 'none';base-uri 'self';frame-ancestors 'none';style-src 'self' 'unsafe-inline';font-src 'self';manifest-src 'self';" always;
        '';
      };
    };
    
    systemd.services.akkoma-config.serviceConfig.ExecStart = lib.mkMerge [[ configScriptPost ]];
    systemd.services.akkoma-config.serviceConfig.ExecReload = lib.mkMerge [[ configScriptPost ]];
  };
}
