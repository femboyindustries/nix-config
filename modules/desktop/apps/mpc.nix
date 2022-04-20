{ pkgs, config, lib, options, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.mpc;
in {
  options.modules.desktop.apps.mpc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    modules.services.mpd.enable = true;

    user.packages = with pkgs; [
      mpc_cli
    ];

  };
}
