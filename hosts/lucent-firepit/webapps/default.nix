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
  
    modules = {
      services = {
        #nextcloud = {
        #  enable = true;
        #  domain = "nextcloud.dark-firepit.cloud";
        #  settings.app.federation = true;
        #};

        #writefreely = {
        #  enable = true;
        #  name = "Corruption Biome";
        #  domain = "blog.dark-firepit.cloud";
        #};

        forgejo = {
          enable = true;
          domain = "git.oat.zone";
          port = 3000;
          enableActions = true;
        };

        matrix.conduit = {
          enable = false;
          domain = "matrix.dark-firepit.cloud";
        };

        vaultwarden = {
          enable = true;
          domain = "vault.aether.gay";
        };

        # not entirely necessary but makes it so that invalid domains and/or direct ip access aborts connection
        # prevents other domains from "stealing" content by settings their dns to our ip
        # this has happened before by the way on the vps. i have no clue how or why
        # update: also optimizes gzip and tls stuff
        nginx-config = {
          enable = true;
        };

        staticSites = {
          "aether.gay".dataDir = "/var/www/aether.gay";
          "dark-firepit.cloud".dataDir = "/var/www/dark-firepit.cloud";
          #"dark-firepit.oat.zone".dataDir = "/var/www/dark-firepit.oat.zone";
          "va11halla.oat.zone".dataDir = "/var/www/va11halla.oat.zone";
          "giger.yugoslavia.fishing".dataDir = "/var/www/giger.yugoslavia.fishing";
          "modfiles.oat.zone".dataDir = "/var/www/modfiles.oat.zone";
          "shop.yugoslavia.best".dataDir = "/var/www/shop.yugoslavia.best";
          "tesco-underground-dev.oat.zone".dataDir = "/var/www/tesco-underground-dev.oat.zone";
          "tesco-underground-dev.oat.zone".auth = { tesco = builtins.readFile /etc/tesco; };
          "oat.zone".dataDir = "/var/www/oat.zone";
          "oat.zone".php = true;
          #"beta-blog.oat.zone".dataDir = "/var/www/beta.blog.oat.zone";
          "yugoslavia.fishing".dataDir = "/var/www/yugoslavia.fishing";
          "yugoslavia.fishing".php = true;
          "educationmath.oat.zone".dataDir = "/var/www/proxy.oat.zone";
          "educationmath.oat.zone".php = true;
          "educationmath.oat.zone".auth = { twh = builtins.readFile /etc/proxy_twh; };
          "rivervalleychocolate.com".dataDir = "/var/www/rivervalleychocolate.com";
          "rivervalleychocolate.com".php = true;
          "tac.yugoslavia.best".dataDir = "/var/www/tac.yugoslavia.best/public";
          "tac.yugoslavia.best".php = true;
          "tac.yugoslavia.best".phpHandlePathing = true;
          "pjsk.oat.zone".dataDir = "/var/www/pjsk.oat.zone";
          "mayf.pink".dataDir = "/var/www/mayf.pink";
          "mayf.pink".php = true;
          "mayf.pink".phpHandlePathing = true;
          "mayf.pink".forceSSL = false;
          #"wint0r.zone".dataDir = "/var/www/wint0r.zone";
          #"puzzle.wint0r.zone".dataDir = "/var/www/puzzle.wint0r.zone";
        };

        nitter = {
          enable = true;
          lightweight = false; # enable if shit gets wild; check config for more info
          port = 3005;
          domain = "nitter.oat.zone";
        };

        libreddit = {
          enable = true;
          domain = "libreddit.oat.zone";
          port = 1950;
        };

        #watch-party = {
        #  enable = true;
        #  port = 1984;
        #};

        matomo = {
          enable = true;
        };

        #code-server = {
        #  enable = true;
        #  domain = "dev-firepit.oat.zone";
        #  port = 4444;
        #};

        /*
        ghost = {
          enable = true;
          domain = "blog.oat.zone";
          port = 1357;
        };
        */

        isso = {
          enable = true;
          port = 1995;
          domain = "comments.oat.zone";
          target = "blog.oat.zone";
        };
      };
    };

    services = {
      nginx.virtualHosts = {
        "oat.zone" = {
          locations."/f/".extraConfig = ''
            add_header Access-Control-Allow-Origin "*";
          '';
          extraConfig = ''
            error_page 404 /404.html;
            error_page 403 /403.html;
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
        "gdicon.oat.zone" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3436/";
          };
        };

        # https://www.edwinwenink.xyz/posts/47-tilde_server/
        # todo: fix this
        "dark-firepit.cloud" = {
          locations."~ ^/~([^/\\s]+?)(/[^\\s]*)?$".extraConfig = ''
            add_header X-debug-message "/home/$1/www$2" always;
            alias /home/$1/www$2;
            index index.html index.htm;
            autoindex on;
          '';
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
