{ options, config, lib, pkgs, ... }:

with lib;
let

in {
  options = {
    user = mkOption {
      type = types.attrs;
      default = {};
      description = "Defaults to apply to all normal users in the system.";
    };
    normalUsers = mkOption {
      type = types.attrsOf (types.submodule { options = {
        conf = mkOption {
          type = types.attrs;
          default = {};
        };
        homeConf = mkOption {
          type = types.attrs;
          default = {};
        };
      };});
      default = {};
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
    configDir = mkOption {
      type = types.path;
      default = ../config;
    };
  };

  config = {
    user = {
      packages = with pkgs; [ wget ];
      extraGroups = [ ];
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

    users.groups = mapAttrs (_: _: {}) config.normalUsers;

    users.users = mapAttrs (username: user: (mkMerge [
      (mkAliasDefinitions options.user)
      user.conf
      {
        isNormalUser = true;
        group = username;
      }
    ])) config.normalUsers;

    #home-manager.users = mapAttrs (username: user: (mkMerge [(mkAliasDefinitions options.home._) user.homeConf])) config.normalUsers;
  };
}
