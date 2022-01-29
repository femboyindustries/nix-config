{ pkgs, lib, options, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.nwg-launchers;
in {
  options.modules.desktop.apps.nwg-launchers = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nwg-launchers ];
  };
}
