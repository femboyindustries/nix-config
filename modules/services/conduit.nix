{ pkgs, config, options, lib, ... }:

with lib;
let
  cfg = config.modules.services.matrix.conduit;
in {
  options.modules.services.matrix.conduit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs._.matrix-conduit;
    };

    domain = mkOption {
      type = types.str;
      default = "localhost";
    };

    user = mkOption {
      type = types.str;
      default = "conduit";
      description = "User account under which Conduit runs.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/conduit";
    };

    httpAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
    };

    httpPort = mkOption {
      type = types.port;
      default = 6167;
    };

    disableRegistration = mkOption {
      type = types.bool;
      default = true;
    };

    disableFederation = mkOption {
      type = types.bool;
      default = false;
    };

    settings = mkOption {
      type = types.submodule {
        freeFormType = format.type;

        options = {
          server_name = mkOption {
            type = types.str;
            example = "matrix.aether.gay";
            default = config.networking.hostName;
            description = "The domain used to be used by the conduit instance for nginx.";
          };

          database_path = mkOption {
            type = types.str;
            default = "/var/lib/conduit";
          };

          database_backend = mkOption {
            type = types.str;
            default = "postgresql";
            example = "rocksdb";
          };

          port = mkOption {
            type = types.int;
            default = 6167;
          };

          max_request_size = mkOption {
            type = types.int;
            default = 52428800; # 50MiB
          };

          allow_registration = mkOption {
            type = types.bool;
            default = false;
          };

          allow_federation = mkOption {
            type = types.bool;
            default = true;
          };

          max_concurrent_requests = mkOption {
            type = types.int;
            default = 64;
          };

          trusted_servers = mkOption {
            type = types.listOf types.str;
            default = [ "matrix.org" ];
          };

          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The address used to access the Conduit instance. Setting this to 127.0.0.1 ensures that it is only possible to reach the server via nginx.";
          };
        };
      };
      default = {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    modules.services.matrix.conduit.settings = {
      server_name = cfg.domain;
      database_dir = cfg.dataDir;
      port = cfg.httpPort;
      enable_registration = !cfg.disableRegistration;
      enable_federation = !cfg.disableFederation;
    };

  };
}
