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

    package = mkOption {
      type = types.package;
      default = pkgs.openssh_hpn;
    };
  };

  config = mkIf cfg.enable {
    programs.ssh.package = cfg.package;

    services.openssh = {
      enable = true;
      package = cfg.package;

      settings = {
        PasswordAuthentication = cfg.requirePassword;
        PermitRootLogin = "no";
        GatewayPorts = "yes";
      };
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
