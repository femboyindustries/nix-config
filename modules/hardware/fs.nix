{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    ssd.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        sshfs
      ];
    }

    (mkIf cfg.ssd.enable {
      services.fstrim.enable = true;
      environment.systemPackages = with pkgs; [
        nvme-cli
      ];
    })
  ]);
}
