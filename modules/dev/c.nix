{ config, lib, pkgs, options, ... }:

with lib;
let
  withLLVM = config.modules.dev.llvm.enable;
  cfg = config.modules.dev.c;
in {
  options.modules.dev.c = {
    enable = mkOption {
      type = types.bool;
      default  = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = if !withLLVM then with pkgs; [
      gcc
    ] else with pkgs; [
      clang_12
#      clang-utils
    ];
  };
}
