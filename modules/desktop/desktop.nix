{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    theme = mkOption {
      type = types.str;
      default = "still";
      description = "Sets a particular styling and wallpaper configuration.";
    };
  };

  config = {
    services.dbus.enable = true;
  };
}
