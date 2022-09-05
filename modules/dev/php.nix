{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.dev.php;
in {
  options.modules.dev.php = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.php ];
  };
}
