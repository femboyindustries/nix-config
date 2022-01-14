{ config, pkgs, inputs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.menus.nwggrid;
in {
  options.modules.desktop.apps.menus.nwggrid = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    executable = mkOption {
      type = types.str;
      default = "${pkgs.nwg-launchers}/bin/nwggrid";
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.apps.nwg-launchers.enable = true;
  };
}
