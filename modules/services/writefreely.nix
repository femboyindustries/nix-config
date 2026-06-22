{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.writefreely;
  domain = "${cfg.subdomain}.${cfg.host}";
  configFile = pkgs.writeText "config.ini" ''
    ${generators.toINI {} cfg.settings}
  '';
in {
  options.modules.services.writefreely = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    stateDir = mkOption {
      type = types.either types.path types.string;
      default = "/var/lib/writefreely";
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

    host = mkOption {
      type = types.str;
      default = null;
    };

    subdomain = mkOption {
      type = types.str;
      default = "blog";
    };

    port = mkOption {
      type = types.port;
      default = 5824;
    };

    openRegistration = mkOption {
      type = types.bool;
      default = false;
    };

    # settings = mkOption {
    #   type = types.attrsOf types.attrs;
    #   default = {};
    # };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.name != null;
        description = "Writefreely instance name unset";
      }

      { assertion = cfg.host != null;
        description = "Writefreely host unset";
      }
    ];

    # environment.systemPackages = with pkgs; [ tmux ];

    services.writefreely = {
      enable = true;
      package = cfg.package;
      stateDir = cfg.stateDir;

      host = domain;

      # nginx.enable = true;
      # nginx.forceSSL = true;

      database.type = "sqlite3";
      database.name = "writefreely.db";
      settings.database.filename = "writefreely";

      settings.server = {
        port = cfg.port;
        bind = "localhost";
        autocert = mkDefault false;
        gopher_port = mkDefault 0;
      };

      settings.app = {
        site_name = cfg.name;
        site_description = cfg.description;
        # host = "https://${domain}:${toString(cfg.port)}";
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

      # "oath.generic".allow_disconnect = mkDefault false;

      admin.name = "aether";
    };

    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
    };

    /*
    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;

      locations."/".extraConfig = ''
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
    */

    /*
    systemd.services.writefreely = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        Restart = "always";
        RestartSec = 20;
        ExecStart =
          "${cfg.package}/bin/writefreely -c '${cfg.stateDir}/config.ini' serve";
        # ExecStart = "${getBin pkgs.tmux}/bin/tmux -S ${cfg.stateDir}/writefreely.sock new -d ${cfg.package}/bin/writefreely";
        AmbientCapabilities =
          optionalString (settings.server.port < 1024) "cap_net_bind_service";
      };

      # preStart = ''
      #   cp -f ${configFile} ${cfg.stateDir}

      #   if [ ! -s ${cfg.stateDir}/keys ];
      #     ${cfg.package}/bin/writefreely keys generate
      #     cp -f ./keys ${cfg.stateDir}
      #   fi
      # '';

      preStart = ''
        if ! test -d "${cfg.stateDir}/keys"; then
          mkdir -p ${cfg.stateDir}/keys

          # Key files end up with the wrong permissions by default.
          # We need to correct them so that Writefreely can read them.
          chmod -R 750 "${cfg.stateDir}/keys"

          ${cfg.package}/bin/writefreely -c '${cfg.stateDir}/config.ini' keys generate
        fi
      '';

      # postStart = ''
      #   ${pkgs.coreutils}/bin/chmod 660 ${cfg.stateDir}/writefreely.sock
      #   ${pkgs.coreutils}/bin/chgrp writefreely ${cfg.stateDir}/writefreely.sock
      # '';
    };
    */

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
