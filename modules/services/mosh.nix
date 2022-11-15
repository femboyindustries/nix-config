{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.glitch-soc;
in {
  options.modules.services.glitch-soc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "feditest.oat.zone";
    };
  };

  config = mkIf cfg.enable {
    services = {
      mastodon = {
        enable = true;
        configureNginx = true;
        localDomain = cfg.domain;
        package = pkgs._.glitch-soc;

        smtp = {
          fromAddress = "mastodon@${cfg.domain}";
          user = "mastodon";
        };

        extraConfig = {
          AUTHORIZED_FETCH = "false";
          LIMITED_FEDERATION_MODE = "true";

          MAX_TOOT_CHARS = "69420";
          MAX_DISPLAY_NAME_CHARS = "32";
          MAX_BIO_CHARS = "69420";
        };
      };
    };
  };
}
