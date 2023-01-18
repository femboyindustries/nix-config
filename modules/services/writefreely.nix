{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.writefreely;
  configFile = pkgs.writeText "config.ini" ''
    ${generators.toINI {} cfg.settings}
  '';
in {
  options.modules.services.writefreely = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.writefreely;
    };

    name = mkOption {
      type = types.str;
      default = null;
    };

    description = mkOption {
      type = types.str;
      default = "";
    };

    domain = mkOption {
      type = types.str;
      default = null;
    };

    port = mkOption {
      type = types.port;
      default = 5824;
    };

    openRegistration = mkOption {
      type = types.bool;
      default = false;
    };

    settings = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.name != null;
        description = "Writefreely instance name unset";
      }

      { assertion = cfg.domain != null;
        description = "Writefreely domain unset";
      }
    ];

    environment.systemPackages = with pkgs; [ tmux ];

    users.users.writefreely = {
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "writefreely";
    };

    users.groups.writefreely = {};

    modules.services.writefreely.settings = {
      server = {
        port = cfg.port;
        bind = "localhost";
        autocert = mkDefault false;
        gopher_port = mkDefault 0;
      };

      database = {
        type = "postgresql";
        username = "writefreely";
#        password = "";
        database = "writefreely";
        host = "localhost";
        port = 3306;
        tls = mkDefault false;
      };

      app = {
        site_name = cfg.name;
        site_description = cfg.description;
        host = "https://${cfg.domain}:${cfg.port}";
        theme = mkDefault "write";
        disable_js = mkDefault false;
        webfonts = mkDefault true;
        simple_nav = mkDefault false;
        wf_modesty = mkDefault false;
        chorus = mkDefault false;
        forest = mkDefault false;
        disable_drafts = mkDefault false;
        single_user = mkDefault false;
        open_registration = cfg.openRegistration;
        open_deletion = mkDefault false;
        min_username_len = mkDefault 3;
        max_blogs = mkDefault 100;
        federation = mkDefault false;
        public_stats = mkDefault true;
        monetization = mkDefault false;
        notes_only = mkDefault false;
        private = mkDefault false;
        local_timeline = mkDefault false;
        update_chekcs = mkDefault false;
        disable_password_auth = mkDefault false;
      };

      "oath.generic".allow_disconnect = mkDefault false;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "writefreely" ];
      ensureUsers = [
        { name = "writefreely";
          ensurePermissions."DATABASE writefreely" = "ALL PRIVELAGES";
        }
      ];
    };

    services.nginx.virtualHosts.${cfg.domain} = {
      forceSSL = true;
      enableACME = true;

      location."/".extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_pass http://127.0.0.1:${toString cfg.port};
        proxy_redirect off;
      '';

      locations."~ ^/.well-known/(webfinger|nodeinfo|host-meta)".extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_pass http://127.0.0.1:${toString cfg.port};
        proxy_redirect off;
      '';

      locations."~ ^/(css|img|js|fonts)/".extraConfig = ''
        root /var/www/example.com/static;
      '';
    };

    systemd.services.writefreely = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ cfg.package ];

      preStart = ''
        cp -f ${configFile} ${cfg.dataDir}

        if [ ! -s ${cfg.dataDir}/keys ];
          ${cfg.package}/bin/writefreely keys generate
          cp -f ./keys ${cfg.dataDir}
        fi
      '';

      serviceConfig = {
        User = "writefreely";
        Type = "forking";
        GuessMainPID = true;
        ExecStart = "${getBin pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/writefreely.sock new -d ${cfg.package}/bin/writefreely";
      };

      postStart = ''
        ${pkgs.coreutils}/bin/chmod 660 ${cfg.dataDir}/writefreely.sock
        ${pkgs.coreutils}/bin/chgrp writefreely ${cfg.dataDir}/writefreely.sock
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
