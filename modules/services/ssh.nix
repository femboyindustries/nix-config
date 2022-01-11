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
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
#    services.sshd.enable = true;
  };
}
