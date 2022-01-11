{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.services.swaylock;

in {
  options.modules.desktop.services.swaylock = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaylock
    ];
  };
}
