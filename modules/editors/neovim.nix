{ config, inputs, pkgs, lib, options, ... }:

with lib;
let
  configDir = config.configDir;
  cfg = config.modules.editors.neovim;
in {
  options.modules.editors.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.configFile = {
/*
      "nvim/init.vim" = {
        text = let
          configt = builtins.readFile "${configDir}/neovim/config.vim";
          coct = builtins.readFile "${configDir}/neovim/coc.vim";
          pluginst = builtins.readFile "${configDir}/neovim/plugins.vim";
          in configt + coct + pluginst;
      };
      "nvim/coc-settings.json" = {
        text = builtins.toJSON (import "${configDir}/neovim/coc-settings.nix");
      };
*/
    };
    home._.programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
#        inputs.asyncrun-vim
        multiple-cursors
        nerdtree
        vim-nix
        fzf-vim
        vim-devicons
      ] ++ (if config.modules.dev.haskell.enable then with pkgs.vimPlugins; [
        ghcid
        fzf-vim
#        inputs.fzf-hoogle-vim
      ] else if config.modules.dev.zig.enable then with pkgs.vimPlugins; [
        zig-vim
      ] else []);

      viAlias = true;
      vimAlias = true;

#      withNodeJS = true;
#      withPython3 = true;
    };
  };
}
