{ config, options, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.editors.doomemacs;
in {
  options.modules.editors.doomemacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
