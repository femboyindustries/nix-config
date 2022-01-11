{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.firefox;
  wayland = config.modules.desktop.sway.enable;
in {
  options.modules.desktop.apps.firefox = {
    enable = mkOption {
      type = types.bool;
      default = trace "penis" false;
    };
  };

  config = mkIf cfg.enable {
/*
    user.packages = with pkgs; [
      firefox-wayland
#      firefox
    ];
*/
    user.packages = abort "sussy balls";
  };
}
