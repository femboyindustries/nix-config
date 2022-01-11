{ config, pkgs, lib, options, ... }:

with lib;
let
  cfg = config.modules.theme;
in {
  options.modules.theme = {
    active = mkOption {
      type = types.str;
      default = "still";
      description = "Theme defaults";
    };
    wallpaper = mkOption {
      type = types.path;
      default = null;
      description = "The main wallpaper";
    };
/*
    gtk = {
      theme = mkOption {
        type = types.str;
        default = "";
        description = "The global GTK theme";
      };
      iconTheme = {
        type = types.str;
        default = "";
        description = "Global GTK icon theme";
      };
      cursorTheme = {
        type = types.str;
        default = "";
        description = "Global GTK cursor theme";
      };
    };
*/
  };

  config = mkIf (cfg.active != "") {
  };
}
