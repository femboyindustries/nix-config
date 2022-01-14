{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.firefox;
  wayland = config.modules.desktop.sway.enable;
in {
  options.modules.desktop.apps.firefox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = trace "penis" (mkIf cfg.enable {
    user.packages = mkMerge (if wayland then with pkgs; [
      firefox-wayland
    ] else with pkgs; [
      firefox
    ]);
  });
}
