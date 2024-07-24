{ config, lib, pkgs, options, ... }:

with lib;
let cfg = config.modules.services.mpd;

in {
  options.modules.services.mpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "httpd"
          name "lucent.fm"
          encoder "opus"
          port "6605"
          bitrate "96000"
          format "48000:16:1"
          always_on "yes"
          tags "yes"
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [ 6600 6605 ];
  };
}
