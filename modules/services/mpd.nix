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

    musicDir = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      user = "aether";
    };

    home._.services.mpd = {
      enable = true;
      musicDirectory = builtins.trace cfg.musicDir cfg.musicDir;
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
}
'' else "");
    };
  };
}
