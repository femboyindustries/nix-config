{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.editors.codium;
in {
  options.modules.editors.codium = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home._.programs.vscode = {
      enable = true;
      package = (pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = with pkgs.vscode-extensions; [
          ms-vsliveshare.vsliveshare
          bbenoist.nix
          zhuangtongfa.material-theme
          pkief.material-icon-theme
          vscodevim.vim
        ] ++ (if config.modules.dev.haskell.enable then [
          haskell.haskell
          justusadam.language-haskell
        ] else [ ]);
      }).overrideAttrs (old: {
        inherit (pkgs.vscodium) pname version;
      });
      extensions = [ ];
    };
  };
}
