{ pkgs, lib, options, config, ... }:

with lib;
let
  cfg = config.modules.desktop.nwg-launchers;
in {
  options.modules.desktop.nwg-launchers = {
    enable = mkOptions {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = [ nwg-launchers ];
  };
}
