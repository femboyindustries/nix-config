{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.services.swayidle;

in {
  options.modules.desktop.services.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
/*
    user.packages = with pkgs; [
      swayidle
    ];
*/
  };
}
