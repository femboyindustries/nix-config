{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.gaming.minecraft;
in {
  options.modules.desktop.gaming.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables Minecraft through the PolyMC launcher";
    };
  };

  config = mkIf cfg.enable {
#    user.packages = [ polymc ];
  };
}
