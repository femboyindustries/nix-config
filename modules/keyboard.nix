{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.keyboard;
in {
  options.keyboard = {
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
    };
    variant = mkOption {
      type = types.str;
      default = "";
    };
  };
}
