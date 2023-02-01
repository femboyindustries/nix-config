{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.ghost;
  # user used to run the Ghost service
  userName = builtins.replaceStrings [ "." ] [ "_" ] cfg.domain;
in {
  options.modules.services.ghost = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    package = mkOption {
      type = types.package;
      default = pkgs._.ghost;
    };
    domain = mkOption {
      type = types.str;
      default = "blog.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 1357;
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/${userName}";
    };
  };

  config = let
    # directory used to save the blog content
    dataDir = cfg.dataDir;
    # script that sets up the Ghost content directory
    setupScript = pkgs.writeScript "${cfg.domain}-setup.sh" ''
      #! ${pkgs.stdenv.shell} -e
      chmod g+s "${dataDir}"
      [[ ! -d "${dataDir}/content" ]] && cp -r "${cfg.package}/content" "${dataDir}/content"
      chown -R "${userName}":"${userName}" "${dataDir}/content"
      chmod -R +w "${dataDir}/content"
      ln -f -s "/etc/${cfg.domain}.json" "${dataDir}/config.production.json"
      [[ -d "${dataDir}/current" ]] && rm "${dataDir}/current"
      ln -f -s "${cfg.package}/current" "${dataDir}/current"
      [[ -d "${dataDir}/content/themes/casper" ]] && rm "${dataDir}/content/themes/casper"
      ln -f -s "${cfg.package}/current/content/themes/casper" "${dataDir}/content/themes/casper"
    '';
  in lib.mkIf cfg.enable {
    # Creates the user and group
    users.users.${userName} = {
      isSystemUser = true;
      group = userName;
      createHome = true;
      home = dataDir;
    };
    users.groups.${userName} = { };

    # Creates the Ghost config
    environment.etc."${cfg.domain}.json".text = ''
      {
        "url": "https://${cfg.domain}",
        "server": {
          "port": ${toString cfg.port},
          "host": "0.0.0.0"
        },
        "database": {
          "client": "mysql",
          "connection": {
            "host": "localhost",
            "user": "${userName}",
            "database": "${userName}",
            "password": "",
            "socketPath": "/run/mysqld/mysqld.sock"
          }
        },
        "mail": {
          "transport": "sendmail"
        },
        "logging": {
          "transports": ["stdout"]
        },
        "paths": {
          "contentPath": "${dataDir}/content"
        }
      }
    '';

    # Sets up the Systemd service
    systemd.services."${cfg.domain}" = {
      enable = true;
      description = "${cfg.domain} ghost blog";
      restartIfChanged = true;
      restartTriggers =
        [ cfg.package config.environment.etc."${cfg.domain}.json".source ];
      requires = [ "mysql.service" ];
      after = [ "mysql.service" ];
      path = [ pkgs.nodejs pkgs.vips ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = userName;
        Group = userName;
        WorkingDirectory = dataDir;
        # Executes the setup script before start
        ExecStartPre = setupScript;
        # Runs Ghost with node
        ExecStart = "${pkgs.nodejs}/bin/node current/index.js";
        # Sandboxes the Systemd service
        AmbientCapabilities = [ ];
        CapabilityBoundingSet = [ ];
        KeyringMode = "private";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [ ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
      environment = { NODE_ENV = "production"; };
    };

    # Sets up the blog virtual host on NGINX
    services.nginx.virtualHosts.${cfg.domain} = {
      # Sets up Lets Encrypt SSL certificates for the blog
      forceSSL = true;
      enableACME = true;
      locations."/" = { proxyPass = "http://127.0.0.1:${toString cfg.port}"; };
      extraConfig = ''
        charset UTF-8;

        add_header Strict-Transport-Security "max-age=2592000; includeSubDomains" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin";
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Content-Type-Options nosniff;
      '';
    };

    # Sets up MySQL database and user for Ghost
    services.mysql = {
      ensureDatabases = [ userName ];
      ensureUsers = [{
        name = userName;
        ensurePermissions = { "${userName}.*" = "ALL PRIVILEGES"; };
      }];
    };
  };
}
