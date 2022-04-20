{ options, config, lib, pkgs, ... }:

with lib;
{
  options = {
    defaultUsers = mkOption {
      type = types.attrs;
      default = {};
      description = "Collection of users";
    };
    home = {
      _ = mkOption {
        type = types.attrs;
        default = {};
        description = "Universal home-level user configuration";
      };
      configFile = mkOption {
        type = types.attrs;
	default = {};
	description = "(XDG) Configuration files managed by home-manager";
      };
    };
    user = mkOption {
      type = types.attrs;
      default = {};
      description = "Universal system-level user configuration";
    };
    configDir = mkOption {
      type = types.path;
      default = ../config;
    };
  };

  config = {
    home-manager.useUserPackages = true;

    user = {
      packages = with pkgs; [ curl ];
      extraGroups = [ "wheel" ];
    };

    home._ = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.home.configFile;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
    };

    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_DESKTOP_DIR = "$HOME";
      };
    };

    users.users = mapAttrs (user: prop: mkMerge [(mkAliasDefinitions options.user) {
      packages = prop.packages;
      extraGroups = prop.extraGroups;
      shell = trace "penis" pkgs."${config.defaultUsers."${user}".shell}";
      home = "/home/${user}";
      isNormalUser = true;
      group = user;
    }]) config.defaultUsers;

    home-manager.users = mapAttrs (user: prop: mkAliasDefinitions options.home._
    ) config.defaultUsers;
  };
}
