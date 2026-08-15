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

    freePorts = {
      from = mkOption {
        type = types.port;
        default = 48000;
      };
      to = mkOption {
        type = types.port;
        default = 54000;
      };
      add = mkOption {
        type = types.listOf types.port;
        default = [];
      };
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

          allowPorts = [
            { start = cfg.freePorts.from; end = cfg.freePorts.to; }
          ] ++ (lib.map (port: { single = port; }) cfg.freePorts.add);
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ] ++ cfg.freePorts.add;
    networking.firewall.allowedUDPPorts = [ cfg.port ] ++ cfg.freePorts.add;

    networking.firewall.allowedTCPPortRanges = [ { from = cfg.freePorts.from; to = cfg.freePorts.to; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = cfg.freePorts.from; to = cfg.freePorts.to; } ];
  };
}
