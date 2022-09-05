{ config, pkgs, lib, options, inputs, ... }:

with lib;
let
  cfg = config.modules.services.minecraft;
in {
  options.modules.services.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    servers = options.services.minecraft-servers.servers;
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers = cfg.servers;
    };
  };
}
