{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.editors.helix;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    
  };
}
