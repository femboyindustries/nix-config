{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.jillo;
in {
  options.modules.services.jillo = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs._.jillo;
    };

    dataDir = mkOption {
      type = types.either [types.path types.str];
    };
  };

  config = mkIf cfg.enable {
    users.users.jillo = {
      group = "jillo";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      shell = "${pkgs.bash}/bin/bash";
    };

    users.groups.jillo = {};

    environment.systemPackages = [ pkgs.nodejs-18_x ];

    systemd.services.jillo = {
      description = "Jillo Discord bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        User = "jillo";
        Group = "jillo";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${pkgs.nodejs-18_x}/bin/npm run start";
        Restart = "on-failure";
      };
    };
  };
}
