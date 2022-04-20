{ pkgs, lib, config, options, ... }:

with lib;
let
  cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cargo
      rustc
    ];

    environment.sessionVariables.RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };
}
