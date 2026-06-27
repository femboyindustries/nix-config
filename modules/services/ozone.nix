{ pkgs, config, options, lib, ... }:

with lib;
let
  cfg = config.modules.services.ozone;
in {
  options.modules.services.ozone = {
    enable = mkEnableOption "ozone";

    package = mkOption {
      type = types.package;
      default = pkgs._.ozone;
      example = "pkgs.ozone";
    };

    domain = mkOption {
      type = types.str;
      default = null;
      description = "Domain to host ozone under; aka OZONE_HOSTNAME";
      example = "ozone.example.com";
    };

    port = mkOption {
      type = types.port;
      default = 2584;
    };

    serviceHandle = mkOption {
      type = types.str;
      default = null;
      description = "Handle of the service account";
      example = "mylabeler.bsky.social";
    };

    serviceDID = mkOption {
      type = types.str;
      default = null;
      description = "DID of the service handle";
      example = "did:plc:7eansezz3nlumwc7gfuiaksv";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ozone = {
      description = "Bluesky Ozone Service";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        # https://github.com/bluesky-social/ozone/blob/main/HOSTING.md#create-the-ozone-env-configuration-file
        # https://github.com/bluesky-social/ozone/blob/main/HOSTING.md#ozone-environment-variables
        envVars = {
          OZONE_SERVER_DID = cfg.serviceDID;
          OZONE_PUBLIC_URL = "https://${cfg.domain}";
          OZONE_ADMIN_DIDS = cfg.serviceDID;
          #OZONE_ADMIN_PASSWORD
          #OZONE_SIGNING_KEY_HEX
          OZONE_DB_POSTGRES_URL = "postgresql:///ozone?host=/run/postgresql";
          OZONE_DB_MIGRATE = "1";

          OZONE_DID_PLC_URL = "https://plc.directory";
          OZONE_APPVIEW_URL = "https://api.bsky.app";
          OZONE_APPVIEW_DID = "did:web:api.bsky.app";

          OZONE_PORT = toString cfg.port;

          LOG_ENABLED = "1";
        };
      in {
        ExecStart = getExe cfg.package;
        Environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
          lib.filterAttrs (_: v: v != null) envVars
        );

        EnvironmentFile = [
          "/etc/ozone-secrets"
        ];
        User = "ozone";
        Group = "ozone";
        StateDirectory = "ozone";
        StateDirectoryMode = "0755";
        Restart = "always";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "ozone" ];
      ensureUsers = [
        { name = "ozone";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";
          proxy_set_header Host $host;

          client_max_body_size 500M;
        '';
      };
    };

    users = {
      users.ozone = {
        group = "ozone";
        isSystemUser = true;
      };
      groups.ozone = { };
    };
  };
}
