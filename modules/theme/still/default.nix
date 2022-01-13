{ config, options, lib, pkgs, ... }:

with lib;
let
  theme = config.modules.theme;
in {
  config = mkIf (theme.active == "still") (mkMerge [
    {
      modules.theme.wallpaper = ./background.png;
      home.configFile = with config.modules; mkMerge [
        (mkIf desktop.services.waybar.enable {
          "waybar" = { source = ./config/waybar; target = "$HOME.config/waybar"; recursive = true; };
	})
/*
        (mkIf desktop.apps.alacritty.enable {
          "alacritty" = { source = ./config/alacritty; recursive = true; };
        })
        (mkIf desktop.apps.wofi.enable {
          "wofi" = { source = ./config/wofi; recursive = true; };
        })
*/
        (mkIf desktop.sway.enable {
          "sway" = { source = ./config/sway; target = "$HOME.config/sway"; recursive = true; };
        })

        (mkIf desktop.nwg-launchers.enable {
          "nwg-launchers/nwggrid/style.css" = { source = ./config/nwggrid/style.css; };
        })
      ];
    }
  ]);
}
