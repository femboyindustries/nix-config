{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.nginx-config;
in {
  options.modules.services.nginx-config = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "oatmealine@disroot.org";
#      defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };

    services.nginx = {
      enable = true;
      #enable = lib.mkForce false;
      
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      commonHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Disable embedding as a frame
        #add_header X-Frame-Options DENY;

        # Prevent injection of code in other mime types (XSS Attacks)
        #add_header X-Content-Type-Options nosniff;

        # Enable XSS protection of the browser.
        # May be unnecessary when CSP is configured properly (see above)
        #add_header X-XSS-Protection "1; mode=block";

        # This might create errors
        #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

      # prevent invalid domains from being used
      virtualHosts."_".locations."/".return = "444";
      virtualHosts."a".locations."/".return = "444";
    };

    networking.firewall.allowedTCPPorts = [ 443 80 ];
    networking.firewall.allowedUDPPorts = [ 443 80 ];
  };
}
