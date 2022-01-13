{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.dev.llvm;
in {
  options.modules.dev.llvm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      llvm_12
    ];
  };
}
