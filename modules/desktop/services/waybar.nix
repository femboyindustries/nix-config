{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.desktop.services.waybar;
in {
  options.modules.desktop.services.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home._.programs.waybar = with pkgs; {
      enable = true;
      settings = [{
        height = 10;
        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "cpu" "memory" "battery#bat0" ];
      }];
      style = builtins.readFile "${config.home.configFile.waybar.source}/style.css";
    };
  };
}
