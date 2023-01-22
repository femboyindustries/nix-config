{ config, lib, pkgs, options, ... }:

# heavily references https://github.com/erdnaxe/nixos-modules/blob/master/services/nitter.nix

with lib;
let
  cfg = config.modules.services.nitter;
in {
  options.modules.services.nitter = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "nitter.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 3005;
    };
    lightweight = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Incase shit gets wild, this will make Nitter a lot more lightweight.
        Some functionality gets removed (videos are not proxied, etc) in exchange for less RAM usage and CPU usage
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      nitter = {
        enable = true;
        package = pkgs.unstable.nitter;
        server = {
          address = "127.0.0.1";
          port = cfg.port;
          hostname = cfg.domain;
          title = "nitter.oat.zone"; # TODO: make this costumizable? not sure
          https = true; # doesn't actually do any encryption, just changes cookie configuration
        };
        preferences = {
          hlsPlayback = true;
          proxyVideos = !cfg.lightweight;
          theme = "Mastodon";
          replaceTwitter = cfg.domain;
        };
      };

      # https://github.com/zedeus/nitter/wiki/Nginx
      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            #add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            #add_header Content-Security-Policy "default-src 'none'; script-src 'self' 'unsafe-inline'; img-src 'self'; style-src 'self' 'unsafe-inline'; font-src 'self'; object-src 'none'; media-src 'self' blob:; worker-src 'self' blob:; base-uri 'self'; form-action 'self'; frame-ancestors 'self'; connect-src 'self' https://*.twimg.com; manifest-src 'self'";
            #add_header X-Content-Type-Options nosniff;
            #add_header X-Frame-Options DENY;
            #add_header X-XSS-Protection "1; mode=block";
          '';
        };
        locations."= /robots.txt" = {
          extraConfig = ''
            # re-defining
            #add_header Strict-Transport-Security $hsts_header;
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            add_header Referrer-Policy origin-when-cross-origin;
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";

            add_header Content-Type text/plain;
            return 200 "User-agent: *\nDisallow: /\n";
          '';
        };
      };
    };

    # fix for a dumb error
    # (this doesn't work or do anything lmfao)
    # genuinely no idea how to fix it atm
    systemd.services.nitter = {
      path = with pkgs; lib.mkForce [ git ];
    };
  };
}
