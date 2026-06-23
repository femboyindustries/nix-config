{ pkgs, lib, config, options, ... }:

with lib;
let
  sites = config.modules.services.staticSites;
  staticSiteModule.options = {
    dataDir = mkOption {
      type = types.oneOf [ types.str types.path ];
      default = null;
    };

    auth = mkOption {
      type = types.attrsOf types.str;
      description = "Basic authentication options. Defines a set of user = password pairs.";
      example = literalExpr ''
        {
          user = "password";
          anotherUser = "anotherPassword";
          /* ... */
        }
      '';
      default = {};
    };

    php = mkOption {
      type = types.bool;
      description = "Does this site use php (phpfpm)?";
      default = false;
    };

    phpHandlePathing = mkOption {
      type = types.bool;
      description = "Let PHP handle pathing (for eg. Laravel)";
      default = false;
    };

    disableLogsForMisc = mkOption {
      type = types.bool;
      description = "Disables access logs for /favicon.ico and /robots.txt";
      default = true;
    };

    denySensitivePaths = mkOption {
      type = types.bool;
      description = "Disables access to paths starting with a . (except well-known) to prevent leaking potentially sensitive data";
      default = true;
    };

    forceSSL = mkOption {
      type = types.bool;
      description = "Redirects HTTP requests to HTTPS.";
      default = true;
    };
  };
in {
  options.modules.services.staticSites = mkOption {
    type = types.attrsOf (types.submodule staticSiteModule);
    example = literalExpression ''
      {
        "aether.gay".dataDir = /var/www/aether.gay;
        "oat.zone".dataDir = "/some/weird/place/oat-zone";
      }
    '';
    default = {};
  };

  config = {
    assertions = mapAttrsToList (domain: _@{dataDir, ...}:
      { assertion = dataDir != null;
        description = "${domain} must specify a dataDir.";
      }) sites;

    services.nginx.virtualHosts = mkMerge (mapAttrsToList (domain: site: {
      ${domain} = {
        locations = mkMerge [
          { "/".basicAuth = site.auth; }

          ( mkIf site.php { "/".index = "index.php index.html"; })

          ( mkIf site.disableLogsForMisc {
            "= /favicon.ico".extraConfig = ''
              access_log off;
              log_not_found off;
            '';
            "= /robots.txt".extraConfig = ''
              access_log off;
              log_not_found off;
            '';
          })

          ( mkIf site.denySensitivePaths {
            "${''~ /\.(?!well-known).*''}".extraConfig = ''deny all;'';
          })

          ( mkIf (site.php && (!site.phpHandlePathing)) {
              "${''~ \.php$''}".extraConfig = ''
                fastcgi_pass  unix:${config.services.phpfpm.pools."${domain}".socket};
                fastcgi_index index.php;
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
              '';
            }
          )

          ( mkIf (site.php && site.phpHandlePathing) {
              "${''~ \.php$''}".extraConfig = ''
                fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
                fastcgi_pass  unix:${config.services.phpfpm.pools."${domain}".socket};
                fastcgi_index index.php;
                include ${pkgs.nginx}/conf/fastcgi_params;
                include ${pkgs.nginx}/conf/fastcgi.conf;
              '';
              "/".extraConfig = ''
                try_files $uri $uri/ /index.php?$query_string;
              '';
            }
          )
        ];
        forceSSL = site.forceSSL;
        addSSL = !site.forceSSL;
        enableACME = true;
        root = site.dataDir;
      };
    }) sites);

    users.users.phpfpm = {
      isSystemUser = true;
      group = "phpfpm";
    };

    users.groups.phpfpm = {};

    services.phpfpm.pools = mkMerge (mapAttrsToList (domain: site: mkIf site.php {
      ${domain} = {
        user = "phpfpm";
        settings = {
          pm = "dynamic";
          "listen.owner" = config.services.nginx.user;
          "pm.max_children" = 200;
          "pm.max_requests" = 2000;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 25;
        };
        phpOptions = ''
          display_errors = on;
        '';
        phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
        phpPackage = pkgs.php;
      };
    }) sites);
  };
}
