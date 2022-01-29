{ config, lib, pkgs, options, ... }:

with lib;
let
  audioSupport = config.modules.hardware.audio.enable;
  cfg = config.modules.services.mpd;

in {
  options.modules.services.mpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    user = mkOption {
      type = types.str;
      default = "";
      description = "Which user MPD should run on";
    };

    musicDir = mkOption {
      type = types.str;
      defaultText = "$XDG_MUSIC_DIR";
    };
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      user = cfg.user;
    };

    home._.services.mpd = {
      enable = true;
      musicDirectory = cfg.musicDir;
      extraConfig =
''
zeroconf_enabled "no"
restore_paused "yes"
replaygain "track"
''
+ (if audioSupport then
''
audio_output {
  type "pipewire"
  name "PipeWire Audio Server"
  server "127.0.0.1"
}
'' else "");
    };
  };
}
