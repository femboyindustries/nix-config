{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.gitea;
in {
  options.modules.services.gitea = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    site = mkOption {
      type = types.str;
      default = "git.oat.zone";
    };
  };

  config = mkIf cfg.enable {
    modules.services.postgres.enable = true;
    services.gitea = {
      enable = true;
      domain = cfg.site;
      rootUrl = "https://${cfg.site}/";
      appName = "Gitea: Fire Pit hosted Git";
      database = {
        type = "postgres";
      };
    };
  };
}
