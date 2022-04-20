{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.zig;
in {
  options.modules.dev.zig = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Adds zig tools to the environment.";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      zig
    ];
  };
}
