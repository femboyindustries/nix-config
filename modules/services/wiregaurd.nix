{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.wireguard;
  opt = options.modules.services.wireguard;
in {
  options.modules.services.wireguard = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the wiregyard VPN service.";
    };
    server = mkOption {
      type = types.bool;
      default = false;
      description = "Configures this module to allow wireguard to act as a VPN provider on this host.";
    };
    interfaces = mkOption {
      type = types.attrs;
      default = {};
      description = "Which interfaces wireguard should atach itself to. The first one is prioritized over all others.";
    };
    port = mkOption {
      type = types.int;
      default = 51820;
      description = "The default listen port.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      networking.firewall.allowedUDPPorts = [ cfg.port ];

      networking.wireguard.interfaces = mapAttrs (i: c: mkMerge [c {
        listenPort = cfg.port;
      }]) (mkAliasDefinitions options.modules.services.wireguard.interfaces);
    }
    (mkIf cfg.server {
      networking.nat = {
        enable = true;
#        externalInterfaces = head cfg.interfaces;
#        internalInterfaces = cfg.interfaces;
      };
    })
  ]);
}
