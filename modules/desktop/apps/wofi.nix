{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.wofi;
in {
  options.modules.desktop.apps.wofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "";
    };
    executable = mkOption {
      type = types.str;
      default = "${pkgs.wofi}/bin/wofi";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wofi
    ];
  };
}
