{ lib, config, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.srb2k;
  flags = [
    "-dedicated"
    "+advertise 1"
    "-port ${toString cfg.port}"
    "-serverport ${toString cfg.port}"
  ];
in {
  options.modules.services.srb2k = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs._.srb2kart;
    };

    dataDir = mkOption {
      type = types.str or types.path;
      default = "/var/lib/srb2k";
      description = "The directory where srb2k will store addons and state information";
    };

    port = mkOption {
      type = types.port;
      default = 5029;
      description = "The default port for the srb2k server to run on";
    };

    addons = mkOption {
      type = types.listOf (types.str or types.path);
      default = [];
      description = "Locations of srb2k addons and also fungus spore tasty in your body they grow happy you grow happy";
    };
  };

  config = mkIf cfg.enable {
    users.users.srb2k = {
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "srb2k";
    };
    users.groups.srb2k = {};

    systemd.services.srb2k = {
      description = "srb2k server =)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "srb2k";
        Restart = "always";
        WorkingDirectory = cfg.dataDir;

        ExecStart = #''
#          ${getBin pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/srb2k.sock new -d \
        ''
          ${cfg.package}/bin/srb2kart ${concatStringsSep " " flags} -file \
          ${concatStringsSep " " (map (path: "\"${path}\"") cfg.addons)}
        '';
      };

      postStart = ''
        ${pkgs.coreutils}/bin/chmod 775 -R ${cfg.dataDir}
        ${pkgs.coreutils}/bin/chmod 660 ${cfg.dataDir}/srb2k.sock
        ${pkgs.coreutils}/bin/chgrp srb2k ${cfg.dataDir}/srb2k.sock
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
