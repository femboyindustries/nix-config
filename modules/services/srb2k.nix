{ lib, config, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.services.srb2k;
  # https://wiki.srb2.org/wiki/Command_line_parameters
  flags = [
    "-dedicated"
    # todo: once declarative config is done,
    # move this over to commands that are ran
    # on startup, will you?
    "+advertise ${toString (if cfg.advertise then 1 else 0)}"
    "-port ${toString cfg.port}"
    "-serverport ${toString cfg.port}"
    "-home ${cfg.dataDir}"
  ] ++ cfg.flags;
in {
  options.modules.services.srb2k = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs._.srb2kart;
    };

    dataDir = mkOption {
      type = types.str or types.path;
      default = "/var/lib/srb2k";
      description = ''
        The directory where SRB2K will store state information.
        Due to limitations with the game itself, the game will
        store state information in a subfolder named '.srb2kart'.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5029;
      description = "The default port for the srb2k server to run on";
    };

    addons = mkOption {
      type = types.listOf (types.str or types.path);
      default = [];
      description = "Locations of SRB2K addons and also fungus spore tasty in your body they grow happy you grow happy";
    };

    advertise = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to advertise this server on the SRB2Kart Master Server (https://ms.kartkrew.org/).";
    };

    flags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional flags to pass to the SRB2K executable. See https://wiki.srb2.org/wiki/Command_line_parameters";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically start the server on boot.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically open ports in the firewall.";
    };

    config = mkOption {
      type = with types; attrsOf (oneOf [ bool int str ]);
      default = {};
      example = literalExpression ''
        {
          maxplayers = 16;
          http_source = "https://yugoslavia.best/srb2kaddons/";
          maxsend = "max";
          servername = with colors; "[EU] ''${lime}yugoslavia.best";
          server_contact = "oat.zone";
        }
      ''; #"
      description = "Options to put into dkartconfig.cfg";
    };

    serv = mkOption {
      type = types.str;
      default = "";
      description = "Additional commands to run on startup via kartserv.cfg";
      example = literalExpression ''
        with colors; '''
          fr_enabled off
          khaosenable off
          
          hm_motd on
          hm_motd_nag on
          hm_motd_name "''${lime}yugoslavia.best"
          hm_motd_tagline "home of bar"
        '''
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.srb2k = {
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "srb2k";
    };
    users.groups.srb2k = {};

    systemd.services.srb2k = let
      tmux = "${getBin pkgs.tmux}/bin/tmux";
      tmuxSock = "${cfg.dataDir}/srb2k.sock";

      startScript = pkgs.writeScript "srb2k-start" ''
        #!${pkgs.runtimeShell}

        umask u=rwx,g=rwx,o=rx
        cd ${cfg.dataDir}
        ${tmux} -S ${tmuxSock} new -d ${cfg.package}/bin/srb2kart ${concatStringsSep " " flags} -file ${concatStringsSep " " (map (path: "\"${path}\"") cfg.addons)}
      '';

      stopScript = pkgs.writeScript "srb2k-stop" ''
        #!${pkgs.runtimeShell}
        
        if ! [ -d "/proc/$1" ]; then
          exit 0
        fi

        ${tmux} -S ${tmuxSock} send-keys quit Enter
      '';

      kartConfig =
        let
          cfgToString = v: if builtins.isBool v then boolToString v else toString v;
        in
        pkgs.writeText "kartconfig.cfg" (
          ''
            // SRB2Kart configuration file.
            // Managed by NixOS configuration
          ''
          + concatStringsSep "\n" (mapAttrsToList (n: v: "${n} \"${cfgToString v}\"") cfg.config)
        );

      kartServ = pkgs.writeText "kartserv.cfg" cfg.serv;
    in {
      description = "srb2k server =)";
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${startScript}";
        ExecStop = "${stopScript} $MAINPID";
        Restart = "always";
        User = "srb2k";
        Type = "forking";
        GuessMainPID = true;
        RuntimeDirectory = "srb2k";
      };

      preStart = ''
        umask u=rwx,g=rwx,o=rx
        mkdir -p ${cfg.dataDir}/.srb2kart
        cd ${cfg.dataDir}
        ${if cfg.config != {} then "ln -sf ${kartConfig} .srb2kart/dkartconfig.cfg" else ""}
        ${if cfg.serv != "" then "ln -sf ${kartServ} .srb2kart/kartserv.cfg" else ""}
        ${pkgs.coreutils}/bin/chown srb2k:srb2k .
        ${pkgs.coreutils}/bin/chmod -R 775 .
      '';

      postStart = ''
        ${pkgs.coreutils}/bin/chmod 660 ${tmuxSock}
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
}
