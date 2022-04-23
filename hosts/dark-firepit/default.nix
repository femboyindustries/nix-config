{ pkgs, inputs, lib, ... }:

let
  keys = import ./authorizedKeys;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  user = {
    packages = with pkgs; [
      git
      curl
    ];
  };

  defaultUsers = {
    aether = {
      packages = [ ];
      shell = "fish";
      extraGroups = [ "wheel" ];
      initialHashedPassword = "!";
      openssh.authorizedKeys.keys = [ keys."aether@subsurface".ssh ];
    };
    oatmealine = {
      packages = [ ];
      shell = "zsh";
      extraGroups = [ "wheel" ];
      initialHashedPassword = "!";
      openssh.authorizedKeys.keys = [ keys."oatmealine@beppy".shh ];
    };
    skye = {
      packages = [ ];
      shell = "fish";
      extraGroups = [ "wheel" ];
      initialHashedPassword = "!";
      openssh.authorizedKeys.keys = [ keys."skye@DESKTOP-VB4940J".shh ];
    };
  };

  keyboard = {
    locale = "en_US.UTF-8";
    variant = "qwerty";
  };

  modules = {
#    theme.active = "still";
    shell.zsh.enable = true;
    shell.fish.enable = true;
    security = {
      isLocalMachine = false;
    };
    desktop = {
      editors = {
        neovim.enable = true;
      };
    };
    dev = {
    };
    services = {
      ssh.enable = true;
      postgres.enable = true;
      gitea = {
        enable = true;
        site = "git.oat.zone";
      };
      wireguard = {
        enable = true;
        server = true;
        externalInterface = "eno1";
        interfaces."wg0" = import ./wireguardInterface.nix;
      };
      webapps = lib.mkMerge (import ./webapps);
    };
  };

  security.doas = {
    extraRules = [
      { users = [ "aether" "oatmealine" "skye" ]; noPass = false; keepEnv = true; }
    ];
  };

  time.timeZone = "Europe/Amsterdam";
}
