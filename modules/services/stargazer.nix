{ pkgs, lib, config, options, ... }:

with lib;
let cfg = config.modules.services.stargazer;
in {
  options.modules.services.stargazer = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    routes = mkOption {
      type = types.attrsOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    services.stargazer = {
      enable = true;
      routes = mapAttrsToList (route: relativeRoot: {
        route = route;
        root = "/var/www/gemini/${relativeRoot}";
      }) cfg.routes;
      # debugMode = true;
    };
  };
}
