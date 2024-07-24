{ config, lib, pkgs, options, inputs, ... }:

with lib;
let
  cfg = config.modules.services.update-idl;
in {
  options.modules.services.update-idl = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.timers."update-itl" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "60m";
        OnUnitActiveSec = "60m";
        Unit = "update-itl.service";
      };
    };
    
    systemd.services."update-itl" = {
      script = ''
        ${pkgs.curl}/bin/curl -X POST https://mayf.pink/itl/update -H "X-Connection: Spiritual"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
