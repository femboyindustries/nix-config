{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.services.jmusicbot;
in {
  options.modules.services.jmusicbot = {
    enable = mkOption {
      description = ''
        JMusicBot is a self-hostable Discord music bot. This service lets
        you host multiple instances of it with seperate configurations.
      '';
      type = types.bool;
      default = false;
    };

    instances = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
          };

          package = mkOption {
            type = types.package;
            default = pkgs.jmusicbot;
          };

          options = mkOption {
            description = ''
              The JMusicBot config, see here: https://jmusicbot.com/config/
            '';
            type = types.submodule {
              options = {
                token = mkOption {
                  type = types.str;
                  description = ''
                    This sets the token for the bot to log in with
                    This MUST be a bot token (user tokens will not work)
                    If you don't know how to get a bot token, please see the guide here:
                    https://github.com/jagrosh/MusicBot/wiki/Getting-a-Bot-Token
                  '';
                };

                owner = mkOption {
                  type = types.int;
                  description = ''
                    This sets the owner of the bot
                    This needs to be the owner's ID (a 17-18 digit number)
                    https://github.com/jagrosh/MusicBot/wiki/Finding-Your-User-ID
                  '';
                  default = 0;
                };

                prefix = mkOption {
                  type = types.str;
                  description = ''
                    This sets the prefix for the bot
                    The prefix is used to control the commands
                    If you use !!, the play command will be !!play
                    If you do not set this, the prefix will be a mention of the bot (@Botname play)
                  '';
                  default = "@mention";
                };

                game = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, it modifies the default game of the bot
                    Set this to NONE to have no game
                    Set this to DEFAULT to use the default game
                    You can make the game "Playing X", "Listening to X", or "Watching X"
                    where X is the title. If you don't include an action, it will use the
                    default of "Playing"
                  '';
                  default = "DEFAULT";
                };

                status = mkOption {
                  type = types.enum ["ONLINE" "IDLE" "DND" "INVISIBLE"];
                  description = ''
                    If you set this, it will modify the default status of bot
                    Valid values: ONLINE IDLE DND INVISIBLE
                  '';
                  default = "ONLINE";
                };

                songinstatus = mkOption {
                  type = types.bool;
                  description = ''
                    If you set this to true, the bot will list the title of the song it is currently playing in its
                    "Playing" status. Note that this will ONLY work if the bot is playing music on ONE guild;
                    if the bot is playing on multiple guilds, this will not work.
                  '';
                  default = false;
                };

                altprefix = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "NONE";
                };

                success = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "🎶";
                };
                warning = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "💡";
                };
                error = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "🚫";
                };
                loading = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "⌚";
                };
                searching = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, the bot will also use this prefix in addition to
                    the one provided above
                  '';
                  default = "🔎";
                };

                help = mkOption {
                  type = types.str;
                  description = ''
                    If you set this, you change the word used to view the help.
                    For example, if you set the prefix to !! and the help to cmds, you would type
                    !!cmds to see the help text
                  '';
                  default = "help";
                };

                npimages = mkOption {
                  type = types.bool;
                  description = ''
                    If you set this, the "nowplaying" command will show youtube thumbnails
                    Note: If you set this to true, the nowplaying boxes will NOT refresh
                    This is because refreshing the boxes causes the image to be reloaded
                    every time it refreshes.
                  '';
                  default = false;
                };

                stayinchannel = mkOption {
                  type = types.bool;
                  description = ''
                    If you set this, the bot will not leave a voice channel after it finishes a queue.
                    Keep in mind that being connected to a voice channel uses additional bandwith,
                    so this option is not recommended if bandwidth is a concern.
                  '';
                  default = false;
                };

                maxtime = mkOption {
                  type = types.int;
                  description = ''
                    This sets the maximum amount of seconds any track loaded can be. If not set or set
                    to any number less than or equal to zero, there is no maximum time length. This time
                    restriction applies to songs loaded from any source.
                  '';
                  default = 0;
                };

                alonetimeuntilstop = mkOption {
                  type = types.int;
                  description = ''
                    This sets the amount of seconds the bot will stay alone on a voice channel until it
                    automatically leaves the voice channel and clears the queue. If not set or set
                    to any number less than or equal to zero, the bot won't leave when alone.
                  '';
                  default = 0;
                };

                playlistsfolder = mkOption {
                  type = types.str;
                  description = ''
                    This sets an alternative folder to be used as the Playlists folder
                    This can be a relative or absolute path
                  '';
                  default = "Playlists";
                };

                updatealerts = mkOption {
                  type = types.bool;
                  description = ''
                    By default, the bot will DM the owner if the bot is running and a new version of the bot
                    becomes available. Set this to false to disable this feature.
                  '';
                  default = true;
                };

                "lyrics.default" = mkOption {
                  type = types.enum ["A-Z Lyrics" "Genius" "MusicMatch" "LyricsFreak"];
                  description = ''
                    Changing this changes the lyrics provider
                    Currently available providers: "A-Z Lyrics", "Genius", "MusicMatch", "LyricsFreak"
                    At the time of writing, I would recommend sticking with A-Z Lyrics or MusicMatch,
                    as Genius tends to have a lot of non-song results and you might get something 
                    completely unrelated to what you want.
                    If you are interested in contributing a provider, please see
                    https://github.com/jagrosh/JLyrics
                  '';
                  default = "A-Z Lyrics";
                };

                aliases = mkOption {
                  type = types.attrsOf (types.listOf types.str);
                  description = ''
                    These settings allow you to configure custom aliases for all commands.
                    Multiple aliases may be given, separated by commas.

                    Example 1: Giving command "play" the alias "p":
                    play = [ p ]

                    Example 2: Giving command "search" the aliases "yts" and "find":
                    search = [ yts, find ]
                  '';
                  default = {
                    settings = [ "status" ];
                    lyrics = [];
                    nowplaying = [ "np" "current" ];
                    play = [];
                    playlists = [ "pls" ];
                    queue = [ "list" ];
                    remove = [ "delete" ];
                    scsearch = [];
                    search = [ "ytsearch" ];
                    shuffle = [];
                    skip = [ "voteskip" ];
                    prefix = [ "setprefix" ];
                    setdj = [];
                    settc = [];
                    setvc = [];
                    forceremove = [ "forcedelete" "modremove" "moddelete" ];
                    forceskip = [ "modskip" ];
                    movetrack = [ "move" ];
                    pause = [];
                    playnext = [];
                    repeat = [];
                    skipto = [ "jumpto" ];
                    stop = [];
                    volume = [ "vol" ];
                  };
                };

                queuetype = mkOption {
                  type = types.enum ["FAIR" "REGULAR"];
                  description = ''
                    Sets the queue type
                    FAIR: Each user gets a fair chance at the queue by rearranging it such that no user can fill it up entirely
                    REGULAR: Queue works as first-come, first-served
                  '';
                  default = "FAIR";
                };

                eval = mkOption {
                  type = types.bool;
                  description = ''
                    If you set this to true, it will enable the eval command for the bot owner. This command
                    allows the bot owner to run arbitrary code from the bot's account.

                    WARNING:
                    This command can be extremely dangerous. If you don't know what you're doing, you could
                    cause horrific problems on your Discord server or on whatever computer this bot is running
                    on. Never run this command unless you are completely positive what you are running.

                    DO NOT ENABLE THIS IF YOU DON'T KNOW WHAT THIS DOES OR HOW TO USE IT
                    IF SOMEONE ASKS YOU TO ENABLE THIS, THERE IS AN 11/10 CHANCE THEY ARE TRYING TO SCAM YOU
                  '';
                  default = false;
                };
              };
            };
          };
        };
      });
    };
  };

  config = let
    dataDir = "/var/lib/jmusicbot";

    # nabbed from https://github.com/NixOS/nixpkgs/blob/61d8fdca02b4647be8d38a94c6f53a7cf072d717/nixos/modules/services/networking/jitsi-videobridge.nix#L11
    toHOCON = x: if isAttrs x && x ? __hocon_envvar then ("\${" + x.__hocon_envvar + "}")
      else if isAttrs x then "{${ concatStringsSep "," (mapAttrsToList (k: v: ''"${k}":${toHOCON v}'') x) }}"
      else if isList x then "[${ concatMapStringsSep "," toHOCON x }]"
      else builtins.toJSON x;
  in mkIf cfg.enable {
    users.users.jmusicbot = {
      group = "jmusicbot";
      home = dataDir;
      createHome = true;
      isSystemUser = true;
      shell = "${pkgs.bash}/bin/bash";
    };

    users.groups.jmusicbot = {};

    system.activationScripts.jmusicbot-data-dir.text = ''
      mkdir -p ${dataDir}
      chown jmusicbot:jmusicbot ${dataDir}
      chmod -R 775 ${dataDir}
    '';

    systemd.services = mapAttrs'
      (name: conf:
        let
          stateDir = "${dataDir}/${name}/";
          configFile = builtins.toFile "config.txt" (toHOCON conf.options);
        in {
          name = "jmusicbot-${name}";
          value = {
            enable = conf.enable;

            # referencing https://jmusicbot.com/running-as-a-service/

            description = "JMusicBot instance ${name}";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            requires = [ "network.target" ];

            serviceConfig = {
              ExecStart = pkgs.writeScript "jmusicbot-start-${name}" ''
                #!${pkgs.runtimeShell}
              
                umask u=rwx,g=rwx,o=rx
                cd ${stateDir}
                ${getExe conf.package} -Dconfig=${configFile}
              '';
              Restart = "always";
              RestartSec = 20;
              User = "jmusicbot";
            };

            preStart = ''
              umask u=rwx,g=rwx,o=rx
              mkdir -p ${stateDir}
              cd ${stateDir}
              ln -sf ${configFile} config.txt
            '';
          };
        }
      ) cfg.instances;
  };
}
