{ config, options, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.alacritty;
in {
  options.modules.desktop.apps.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    executable = mkOption {
      type = types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty
    ];
    home._.programs.alacritty = {
      enable = true;
/*
      settings = {
        background_opacity = theme.backgroundOpacity;
        font = {
          size = 12;
          normal.family = theme.font.mono;
          bold.family = theme.font.mono;
          italic.family = theme.font.mono;
        };
        colors = {
          primary = {
            background = theme.colors.background;
            foreground = theme.colors.foreground;
          };
          normal = theme.colors.backgroundScheme;
          bright = theme.colors.foregroundScheme;
        };
      };
*/
    };
  };
}
