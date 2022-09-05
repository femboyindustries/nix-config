{ pkgs, lib, config, options, ... }:

# uncomment any of this and i will uncomment the entirety of russia above your house
{ /*
with lib; with types;
let
  cfg = config.modules.services.webapps;
in {
  options.modules.services.webapps = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    webapps = mkOption {
      type = attrsOf (submodule { options = {
        nginx = mkOption {
          type = submodule { options = options.services.nginx.virtualHosts.type.getSubModules; };
          default = {};
        };
        phpfpm = {
          enable = mkOption {
            type = bool;
            default = false;
          };
          config = mkOption {
            type = submodule { options = options.services.phpfpm.pools.type.getSubModules; };
            default = {
              settings = {
              "pm" = mkDefault "dynamic";
              "pm.max_children" = mkDefault 16;
              "pm.max_requests" = mkDefault 500;
              "pm.start_servers" = mkDefault 1;
              "pm.min_spare_servers" = mkDefault 1;
              "pm.max_spare_servers" = mkDefault 3;
#              "php_admin_value[error_log]" = mkDefault "${app.root}/log";
              "php_admin_flag[log_errors]" = mkDefault true;
              "catch_workers_output" = mkDefault true;
              };
              phpEnv."PATH" = makeBinPath [ pkgs.php ];
            };
          };
        };
        root = mkOption {
          type = path;
          default = null;
        };
      }; });
      default = {};
    };
  };

  config = mkIf cfg.enable
    (mkMerge (mapAttrsToList (appName: app: let username = concatStringsSep "-" (splitString "." appName); in trace appName (mkMerge [
      {
        users.users.${username} = mkMerge [
          {
            isSystemUser = true;
            group = username;
          }
          (mkIf (app.root != null) {
            createHome = true;
            home = app.root;
          })
        ];

#        users.groups.${username} = {};

        services.nginx = {
          enable = true;
          virtualHosts.${appName} = mkMerge [
            app.nginx
            (mkIf (app.root != null) { root = mkDefault app.root; })
          ];
        };
      }

      (mkIf app.phpfpm.enable {
        modules.dev.php.enable = true;
        services.phpfpm.pools.${appName} = mkMerge [ app.phpfpm.config {
          user = username;
          default."listen.owner" = config.services.nginx.user;
        }];
      })
    ])) cfg.webapps
  ));
}
*/ }
