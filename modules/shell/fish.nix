{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home._.programs.fish = {
      enable = true;
    };
  };
}
