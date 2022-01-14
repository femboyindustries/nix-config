{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.fish;
  cfgDir = config.configDir;
in {
/*
  options.modules.shell.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    executable = mkOption {
      type = types.str;
      default = "${pkgs.fish}/bin/fish";
    };
  };

  config = cfg.enable {
    home._.programs.fish = {
      enable = true;
    };

    home.configFile = {
      "fish" = {
        source = "${cfgDir}/fish";
        target = "$HOME.config/fish";
      };
    };
  };
*/
}
