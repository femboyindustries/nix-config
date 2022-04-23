{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.wireguard;
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

    externalInterface = mkOption {
      type = types.str;
      default = null;
      description = "";
    };

    interfaces = mkOption {
      type = options.networking.wireguard.interfaces.type;
      default = {};
      description = "Which interfaces wireguard should attach itself to.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.server {
      assertions = [
        { assertion = cfg.externalInterface != null;
          description = "External interface must be set if wiregaurd is to be setup as a server.";
        }
      ];

      networking = mkMerge (
        [{
          nat.enable = true;
          nat.externalInterface = cfg.externalInterface;
          nat.internalInterfaces = filter (i: i != cfg.externalInterface) (attrNames cfg.interfaces);
        }] ++

        (mapAttrsToList (iname: iattrs: {
          firewall.allowedUDPPorts = [ iattrs.listenPort ];

          wireguard.interfaces.${iname} = mkMerge [ iattrs {
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';

            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';
          }];
        }) cfg.interfaces)
      );
    })

/*
    (mkIf (!cfg.server) (mkMerge [
      { networking.wireguard.interfaces = cfg.interfaces; }
      (mapAttrs (_: iattrs: { networking.firewall.allowedUDPPorts = iattrs.listenPort; }) cfg.interfaces)
    ]))
*/
  ]);
}
