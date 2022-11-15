{ pkgs, options, config, lib, ... }:

with lib;
let
  cfg = config.modules.hyprpaper;
in {
  options.modules.hyprpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
  };
}
