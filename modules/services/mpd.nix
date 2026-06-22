{ config, lib, pkgs, options, ... }:

with lib;
let cfg = config.modules.services.mpd;

in {
  options.modules.services.mpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    domain = mkOption {
      type = types.str;
      default = "station.dark-firepit.cloud";
    };
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "httpd"
          name "lucent.fm"
          encoder "lame"
          port "6601"
          bitrate "128000"
          format "48000:16:2"
          always_on "yes"
          tags "yes"
        }

        audio_output {
          type "httpd"
          name "lucent.fm.lbr"
          encoder "lame"
          port "6602"
          bitrate "96000"
          format "48000:16:2"
          always_on "yes"
          tags "yes"
        }
      '';
    };

    services.mympd.enable = true;
    services.mympd.settings.http_port = 6603;
      # ssl = true;

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://127.0.0.1:6603";
      # locations."/control".proxyPass = "http://127.0.0.1:6600";
      locations."/radio".proxyPass = "http://127.0.0.1:6601";
      locations."/radiolbr".proxyPass = "http://127.0.0.1:6602";
    };

    services.mpdscribble.enable = true;
    services.mpdscribble.endpoints."last.fm" = {
      username = "dark-firepit";
      passwordFile = "/var/lib/mpd/lastfm_pass";
    };
  };
}
