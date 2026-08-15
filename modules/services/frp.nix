{ pkgs, config, options, lib, ... }:

with lib;
let
  cfg = config.modules.services.frp;
in {
  options.modules.services.frp = {
    enable = mkEnableOption "frp";

    package = mkOption {
      type = types.package;
      default = pkgs.frp;
      example = "pkgs.frp";
    };

    port = mkOption {
      type = types.port;
      default = 7000;
    };
  };

  config = mkIf cfg.enable {
    services.frp = {
      instances.default = {
        enable = true;
        role = "server";
        settings = {
          #bindAddr = "0.0.0.0";
          bindPort = cfg.port;
          kcpBindPort = cfg.port;

          auth.method = "token";
          auth.tokenSource.type = "file";
          auth.tokenSource.file.path = "/etc/frp-token";
        };
      };
    };
  };
}
