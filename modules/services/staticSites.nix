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
        locations."/".basicAuth = site.auth;
        locations."~ \.php$".extraConfig = mkIf site.php ''
          fastcgi_pass  unix:${config.services.phpfpm.pools."${domain}".socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
        locations."/".index = mkIf site.php "index.php index.html";
        forceSSL = true;
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
        phpEnv."PATH" = lib.makeBinPath [ pkgs.unstable.php ];
        phpPackage = pkgs.unstable.php;
      };
    }) sites);
  };
}
