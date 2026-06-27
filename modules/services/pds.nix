{ pkgs, config, options, lib, ... }:

with lib;
let
  cfg = config.modules.services.pds;
in {
  options.modules.services.pds = {
    enable = mkEnableOption "pds";

    package = mkOption {
      type = types.package;
      default = pkgs.bluesky-pds;
      example = "pkgs.bluesky-pds";
    };

    domain = mkOption {
      type = types.str;
      default = null;
      description = ''
        Domain to host the PDS under.

        NOTE that you must also have set up a wildcard DNS entry with the proper TLS certificates;
        eg. if `domain` is `example.com`, then both `example.com` and `*.example.com` must have valid
        A records and certificates.

        The NGINX configuration here will assume both are registered under `example.com` and set
        `useACMEHost` to the given domain.
      '';
      example = "pds.example.com";
    };

    port = mkOption {
      type = types.port;
      default = 2583;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.domain != null;
        description = "@config.modules.services.pds.domain@ must not equal null";
      }
    ];

    services.bluesky-pds = {
      enable = true;
      pdsadmin.enable = true;
      package = cfg.package;
      settings = {
        # FUCK bsky pds configuration
        # SHOUTOUTS to https://lunareclipse.zone/blog/016-how-to-setup-a-bluesky-pds/#the-actual-environment-file
        # ALSO SEE https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/config/env.ts

        # http
        PDS_HOSTNAME = cfg.domain;
        PDS_PORT = cfg.port;

        # basic info
        PDS_SERVICE_NAME = "${cfg.domain} PDS";
        PDS_SERVICE_DID = "did:web:${cfg.domain}";
        #PDS_VERSION = "haiii:3333"; # got too silly
        #PDS_VERSION = "${cfg.package.version}-silly"; # still too silly
        PDS_ACCEPTING_REPO_IMPORTS = "true"; # allow migrations
        PDS_BLOB_UPLOAD_LIMIT = "52428800";

        PDS_SERVICE_HANDLE_DOMAINS = ".${cfg.domain},.pawjob.invalidhandle.com";

        # invites
        PDS_INVITE_REQUIRED = "true";
        #PDS_INVITE_INTERVAL = "";
        #PDS_INVITE_EPOCH = "0";

        # links (used in registration form)
        PDS_HOME_URL = "https://yugoslavia.best/";
        PDS_PRIVACY_POLICY_URL = "https://youtu.be/YdDFTEK53fI";
        PDS_SUPPORT_URL = "https://samsung.com/";
        PDS_TERMS_OF_SERVICE_URL = "https://youtu.be/QahiS1Tn_i4";
        PDS_CONTACT_EMAIL_ADDRESS = "pds@oat.zone";
        # branding (used in oauth provider)
        PDS_LOGO_URL = "https://at.yugoslavia.best/favicon.png";
        PDS_PRIMARY_COLOR = "#00ffff";
        PDS_ERROR_COLOR = "#ff00ff";
        PDS_WARNING_COLOR = "#ffff00";

        # database (sqlite)
        PDS_DATA_DIRECTORY = "/var/lib/pds/data";
        # blobstore (disk)
        PDS_BLOBSTORE_DISK_LOCATION = "/var/lib/pds/data/blocks";

        # environment
        PDS_DID_PLC_URL = "https://plc.directory";
        PDS_BSKY_APP_VIEW_URL = "https://api.bsky.app";
        PDS_BSKY_APP_VIEW_DID = "did:web:api.bsky.app";
        # crawlers shamlessly stolen from
        # <https://compare.hose.cam>
        PDS_CRAWLERS = concatStringsSep "," [
          "https://bsky.network"
          "https://relay.cerulea.blue"
          "https://relay.fire.hose.cam"
          "https://relay2.fire.hose.cam"
          "https://relay3.fr.hose.cam"
          "https://relay.hayescmd.net"
          "https://relay.xero.systems"
          "https://relay.upcloud.world"
          "https://relay.feeds.blue"
          "https://atproto.africa"
          "https://relay.whey.party"
        ];
        PDS_MOD_SERVICE_URL = "https://mod.yugoslavia.best";
        PDS_MOD_SERVICE_DID = "did:plc:7ky7ww26gqwhdofqrxxdy7hb";
        PDS_REPORT_SERVICE_URL = "https://mod.yugoslavia.best";
        PDS_REPORT_SERVICE_DID = "did:plc:7ky7ww26gqwhdofqrxxdy7hb";

        # debug
        LOG_ENABLED = "true";
        LOG_LEVEL = "info";
      };

      environmentFiles = [
        "/var/lib/pds/secrets.env"
      ];
    };

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      #enableACME = true;
      useACMEHost = "${cfg.domain}";
      serverAliases = [ "*.${cfg.domain}" ];

      # surely there's a better way to do this
      locations."= /" = {
        root = "/var/www/${cfg.domain}";
        extraConfig = ''
          if ($host != "${cfg.domain}") {
            return 301 $scheme://${cfg.domain}$request_uri;
          }
          try_files /index.html =404;
        '';
      };
      locations."= /favicon.png" = {
        root = "/var/www/${cfg.domain}";
        extraConfig = ''
          if ($host != "${cfg.domain}") {
            return 301 $scheme://${cfg.domain}$request_uri;
          }
          try_files /favicon.png =404;
        '';
      };
      locations."= /favicon.ico" = {
        root = "/var/www/${cfg.domain}";
        extraConfig = ''
          if ($host != "${cfg.domain}") {
            return 301 $scheme://${cfg.domain}$request_uri;
          }
          try_files /favicon.ico =404;
        '';
      };

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

      # https://gist.github.com/mary-ext/6e27b24a83838202908808ad528b3318#method-5-self-hosted-pds-for-uk-users
      locations."/xrpc/app.bsky.unspecced.getAgeAssuranceState" = {
        extraConfig = ''
      		default_type application/json;
      		add_header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy" always;
      		add_header access-control-allow-origin "*" always;
          add_header X-Frame-Options SAMEORIGIN always;
          add_header X-Content-Type-Options nosniff;
      		return 200 '{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured"}';
        '';
      };
      locations."/xrpc/app.bsky.ageassurance.getState" = {
        extraConfig = ''
      		default_type application/json;
      		add_header access-control-allow-headers "authorization,dpop,atproto-accept-labelers,atproto-proxy" always;
  				add_header access-control-allow-origin "*" always;
          add_header X-Frame-Options SAMEORIGIN always;
          add_header X-Content-Type-Options nosniff;
  				return 200 '{"state":{"lastInitiatedAt":"2025-07-14T14:22:43.912Z","status":"assured","access":"full"},"metadata":{"accountCreatedAt":"2022-11-17T00:35:16.391Z"}}';
        '';
      };
    };
  };
}
