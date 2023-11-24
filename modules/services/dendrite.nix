{ pkgs, config, lib, options, ... }:

with lib;
let
  cfg = config.modules.services.dendrite;
  fullDomain = "${cfg.prefix}.${cfg.hostDomain}";
  maxUploadMegabytes = 600;
in {
  options.modules.services.dendrite = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    hostDomain = mkOption {
      type = types.str;
      default = null;
    };

    prefix = mkOption {
      type = types.str;
      default = "matrix";
    };

    port = mkOption {
      type = types.port;
      default = 8008;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.hostDomain != null;
        description = "@config.modules.services.dendrite.hostDomain@ must not equal null";
      }
    ];

    services.dendrite = {
      enable = true;
      httpPort = cfg.port;
      # httpsPort = cfg.port;
      tlsCert = "/var/lib/dendrite_keys/server.crt";
      tlsKey = "/var/lib/dendrite_keys/server.key";
      loadCredential = [ "private_key:/var/lib/dendrite_keys/private/private_key.pem" ];
      environmentFile = "/var/lib/dendrite_keys/registration_secret";
      settings = {
        global = {
          server_name = cfg.hostDomain;
          private_key = "/var/lib/dendrite_keys/private/private_key.pem";
          presence = {
            enable_inbound = true;
            enable_outbound = true;
          };
        };
        client_api = {
          registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
        };
        media_api = {
          max_file_size_bytes = maxUploadMegabytes;
          dynamic_thumbnails = true;
        };
      };

    };

    services.nginx.virtualHosts."${fullDomain}" = {
      forceSSL = true;
      enableACME = true;

      #listen = [
      #  { addr = "0.0.0.0";
      #    port = 443;
      #    ssl = true;
      #  }
      #  { addr = "[::]";
      #    port = 443;
      #    ssl = true;
      #  }
      #];

      locations."/_matrix".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      #locations."/_matrix".proxyPass = "https://localhost:${toString cfg.port}";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-RealIP $remote_addr;
        proxy_read_timeout 600;
        client_max_body_size ${toString maxUploadMegabytes}M;
      '';
    };

    services.nginx.virtualHosts."${cfg.hostDomain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/.well-known/matrix/server".return = "200 '{ \"m.server\": \"${fullDomain}:443\"}'";

	    # locations."/.well-known/matrix/client".return = "200 '{ \"m.homserver\": { \"base_url\": \"https://${cfg.hostDomain}\"} }'";
      locations."/.well-known/matrix/client".extraConfig = ''
        add_header Access-Control-Allow-Origin '*';
        return 200 '{ \"m.homeserver\": { \"base_url\": \"https://${fullDomain}\"} }';
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.firewall.allowedUDPPorts = [ 80 443 ];
  };
}
