{ options, config, lib, pkgs, ... }:

with lib;
#with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables audio support via PipeWire.";
    };
    enableExtraCompat = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the PulseAudio, ALSA, and JACK PipeWire compatability servers.";
    };
  };

  config = mkIf cfg.enable {
#    sound.enable = false;
    hardware.pulseaudio.enable = false; # fuck off pulseaudio
    services.pipewire = mkMerge [
      {
        enable = true;
      }
      (mkIf cfg.enableExtraCompat
      {
        alsa.enable = cfg.enableExtraCompat;
        alsa.support32Bit = cfg.enableExtraCompat;
        pulse.enable = cfg.enableExtraCompat;
        jack.enable = cfg.enableExtraCompat;
      })
    ];

    user.extraGroups = [ "audio" ];
  };
}
