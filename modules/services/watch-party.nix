{ config, lib, pkgs, options, inputs, ... }:

with lib;
let
  cfg = config.modules.services.watch-party;
in {
  options.modules.services.watch-party = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "watch-party.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 1984;
    };
  };

  config = mkIf cfg.enable {
    services = {
      #watch-party = {
      #  enable = true;
      #  port = cfg.port;
      #};

      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
    };
  };
}
