{ config, options, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.obs;
in {
  options.modules.desktop.apps.obs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
/*
    user.packages = with pkgs; [
      obs-studio
    ];
*/
  };
}
