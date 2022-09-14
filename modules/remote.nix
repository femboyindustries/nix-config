{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.remote;
in {
  options.modules.remote = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    keys = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = [];
    };
    packages = mkOption {
      type = types.nullOr (types.listOf types.package);
      default = [];
    };
    shell = mkOption {
      type = types.nullOr types.package;
      default = pkgs.bash;
    };
  };

  config = mkIf cfg.enable {
    users.users.remote = {
      description = "Generic remote server access user";
      createHome = true;
      #isSystemUser = true;
      isNormalUser = true;
      group = "remote";
      extraGroups = [ "nix-users" "yugoslavia" ];
      initialHashedPassword = "!";
      openssh.authorizedKeys.keys = cfg.keys;
      packages = cfg.packages;
      shell = cfg.shell;
    };

    #home-manager.users.remote.home = {
    #  sessionVariables = {
    #    NIX_REMOTE = "daemon";
    #  };
    #};

    users.groups.remote = {};
  };
}
