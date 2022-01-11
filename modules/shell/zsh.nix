{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.zsh;
  inherit (config) configDir;
in {
  options.modules.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    executable = mkOption {
      type = types.str;
      default = "${pkgs.fish}/bin/zsh";
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nix-zsh-completions ];

#    home.configFile."zsh".source = "${configDir}/zsh";

    home._.programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
#      dotDir = "${config.home.configFile."zsh".source}";
     dotDir = ".config/zsh";
      history = {
        path = "$XDG_DATA_HOME/zsh/zsh_history";
        save = 1000;
        size = 1000;
      };
    };
  };
}
