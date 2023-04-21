{ options, config, lib, pkgs, ... }:

with lib;
#with lib.my;
let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Provide system SSH support though OpenSSH.";
    };

    requirePassword = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      permitRootLogin = "no";
      passwordAuthentication = cfg.requirePassword;
/*
      settings = {
        PasswordAuthentication = cfg.requirePassword;
        PermitRootLogin = "no";
      };
*/
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
