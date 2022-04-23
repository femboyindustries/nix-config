{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.webapps;
in {
  options.modules.services.webapps = mkOption {
    type = types.attrsOf types.attrs;
    default = {};
  };

  config = mkMerge (
/*
    [{ services.nginx.enable = true; }] ++

    # Generic configuration
    (mapAttrsToList (appName: app: let username = lib.intersperse "-" (lib.splitString "." appName); in mkMerge [
      {
        assertions = [{
          assertion = (types.enum ["generic" "phpfpm"]).check app.platform;
          description = "Please specify a webapp platform for ${appName}. The possible platforms are: \"generic\", \"phpfpm\"";
        }];

        users.users.${username} = mkMerge [
          {
            isSystemUser = true;
            group = appName;
          }
          (mkIf (app.root != null) {
            createHome = true;
            home = app.root;
          })
        ];

        users.groups.${username} = username;

        services.nginx.virtualHosts."${appName}" = app.nginx;
      }

      # phpfpm-specific configuration
      (mkIf (app.platform == "phpfpm") {
        modules.dev.php.enable = true;

        services.phpfpm.pools.${appName} = {
          user = appName;
          settings = mkMerge [{
            "listen.owner" = config.services.nginx.user;
            "pm" = "dynamic";
            "pm.max_children" = 16;
            "pm.max_requests" = 500;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 1;
            "pm.max_spare_servers" = 3;
            "php_admin_value[error_log]" = "${app.root}/log";
            "php_admin_flag[log_errors]" = true;
            "catch_workers_output" = true;
          } app.phpfpm];
          phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
        };
      })
    ]) cfg)
*/[]
  );
}
