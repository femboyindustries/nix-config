{ config, lib, pkgs, ... }:

with lib;
let
in {
  config = {
    services.cohost-blogger = {
      enable = true;
      domain = "blog.oat.zone";
      port = 3500;
    };
    services.nlw-api = {
      enable = true;
      domain = "nlw.oat.zone";
      apiKey = builtins.readFile /etc/sheets-api-key;
      #apiKey = "";
      port = 1995;
    };
    services.cardgen = {
      enable = true;
      port = 25290;
    };
    services.gd-icon-renderer-web = {
      enable = true;
      port = 3435;
      domain = "gdicon.oat.zone";
    };

    modules.services = {
      forgejo = {
        enable = true;
        domain = "git.oat.zone";
        port = 3000;
        enableActions = true;
      };

      # not entirely necessary but makes it so that invalid domains and/or direct ip access aborts connection
      # prevents other domains from "stealing" content by settings their dns to our ip
      # this has happened before by the way on the vps. i have no clue how or why
      # update: also optimizes gzip and tls stuff
      nginx-config = {
        enable = true;
      };

      staticSites = {
        "va11halla.oat.zone".dataDir = "/var/www/va11halla.oat.zone";
        "giger.yugoslavia.fishing".dataDir = "/var/www/giger.yugoslavia.fishing";
        "modfiles.oat.zone".dataDir = "/var/www/modfiles.oat.zone";
        "shop.yugoslavia.best".dataDir = "/var/www/shop.yugoslavia.best";
        "shop.yugoslavia.best".forceSSL = false;
        #"tesco-underground-dev.oat.zone".dataDir = "/var/www/tesco-underground-dev.oat.zone";
        #"tesco-underground-dev.oat.zone".auth = { tesco = builtins.readFile /etc/tesco; };
        "oat.zone".dataDir = "/var/www/oat.zone";
        "oat.zone".php = true;
        "goungle.oat.zone".dataDir = "/var/www/goungle.oat.zone";
        #"beta-blog.oat.zone".dataDir = "/var/www/beta.blog.oat.zone";
        "yugoslavia.fishing".dataDir = "/var/www/yugoslavia.fishing";
        "yugoslavia.fishing".php = true;
        "rivervalleychocolate.com".dataDir = "/var/www/rivervalleychocolate.com";
        "rivervalleychocolate.com".php = true;
        #"pjsk.oat.zone".dataDir = "/var/www/pjsk.oat.zone";
        "mayf.pink".dataDir = "/var/www/mayf.pink";
        "mayf.pink".php = true;
        "mayf.pink".phpHandlePathing = true;
        "promotion.yugoslavia.best".dataDir = "/var/www/promotion.yugoslavia.best/public";
        "promotion.yugoslavia.best".php = true;
        "promotion.yugoslavia.best".phpHandlePathing = true;
        "promotion.yugoslavia.best".forceSSL = false;
        #"star.yugoslavia.best".dataDir = "/var/www/star.yugoslavia.best";
        #"star.yugoslavia.best".forceSSL = false;
        #"wint0r.zone".dataDir = "/var/www/wint0r.zone";
        #"puzzle.wint0r.zone".dataDir = "/var/www/puzzle.wint0r.zone";
        "femboy.industries".dataDir = "/var/www/femboy.industries";
        "dragongirl.tf".dataDir = "/var/www/dragongirl.tf";
      } // (listToAttrs (map (value: {
        name = "${value}.femboy.industries";
        value = { dataDir = "/var/www/femboy.industries/_subdomains/${value}/"; };
      }) []));

      matomo = {
        enable = true;
      };
    };

    services = {
      nginx.virtualHosts = {
        "yugoslavia.best" = {
          locations."/assets/".extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
          '';
        };
        "oat.zone" = {
          locations."/.well-known/".extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
          '';
          locations."/f/".extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
          '';
          locations."/f/cards/gen".extraConfig = ''
            rewrite /f/cards/gen/(.*) /$1 break;
            proxy_pass http://127.0.0.1:25290;
            proxy_redirect off;
          '';
          locations."/f/sponge-or-lime/api".extraConfig = ''
            rewrite /f/sponge-or-lime/api/(.*) /$1 break;
            proxy_pass http://127.0.0.1:1540;
            proxy_redirect off;
          '';
          extraConfig = ''
            error_page 404 /404.html;
            error_page 403 /403.html;
          '';
        };
        "femboy.industries" = {
          locations."/_subdomains".extraConfig = ''
            deny all;
            return 404;
          '';
        };
        # todo: move to flake
        "gdpstest.oat.zone" = {
          enableACME = true;
          forceSSL = false;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:1982/";
          };
          extraConfig = ''
            client_max_body_size 500M;
          '';
        };
        # todo: move to flake
        "jillo.oat.zone" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:15385/";
          };
        };
        "radio.oat.zone" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:24454/";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
            '';
          };
        };

        #"git.oat.zone" = {
        #  forceSSL = true;
        #  enableACME = true;
        #  root = "/var/www/temporarily-down";
        #  extraConfig = ''
        #    error_page 503 /index.html;
        #  '';
        #  locations."/".extraConfig = ''
        #    return 503;
        #    try_files /index.html =404;
        #  '';
        #};
      };
    };
  };
}
