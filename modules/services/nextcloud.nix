{ pkgs, config, lib, options, ... }:

with lib;
let
  cfg = config.modules.services.nextcloud;
in {
  options.modules.services.nextcloud = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    domain = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.domain != null;
        description = "Nextcloud requires a domain.";
      }
    ];

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud24;
      hostName = cfg.domain;
      config.adminpassFile = "/etc/nextcloudpass";
    };
  };
}
