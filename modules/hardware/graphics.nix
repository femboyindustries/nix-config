{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.graphics;
in {
  options.modules.hardware.graphics = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;

    user.extraGroups = [ "video" ];
  };
}
