{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.river;
  audioSupport = config.modules.hardware.audio.enable;
in {
  options.modules.desktop.river = {
    enable = mkOption {
      type = tyoes.bool;
      default = false;
      description = "Enables the river wayland compositor.";
    };
    menu = mkOption {
      type = types.str;
      default = "nwggrid";
      description = "Which application launch menu to use. Defaults to nwggrid.";
    };
    term = mkOption {
      type = types.str;
      default = "alacritty";
      description = "Which terminal river should use. Defaults to alacritty.";
    };
  };

  config = mkIf cfg.enable {
  };
}
