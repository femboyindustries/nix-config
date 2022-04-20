{ pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  defaultUsers = {
    aether = {
      packages = with pkgs; with pkgs._; [ htop discord youtube-dl inkscape audacity dolphin steam bitwarden blender neofetch krita celluloid imv firefox zathura zip unzip ffmpeg pijul pavucontrol killall ripcord steam-run appimage-run openjdk11 ];
      uid = 1024;
      isNormalUser = true;
      shell = "zsh";
      extraGroups = [ "wheel" ];
    };
  };

  keyboard = {
    locale = "en_US.UTF-8";
    variant = "qwerty";
  };

  modules = {
#    theme.active = "still";
    shell.zsh.enable = true;
    security = {
      isLocalMachine = true;
    };
    desktop = {
      sway = {
        enable = true;
        term = "alacritty";
      };
      apps = {
        mpc.enable = true;
        alacritty.enable = true;
        obs.enable = true;
        firefox.enable = true;
        menus = {
          nwggrid.enable = true;
        };
      };
      editors = {
         neovim.enable = true;
         codium.enable = true;
      };
      gaming = {
        minecraft.enable = true;
      };
    };
    dev = {
      llvm.enable = true;
      haskell = {
        enable = true;
        version = "ghc902";
      };
      c.enable = true;
      rust.enable = true;
      zig.enable = true;
    };
    services = {
      ssh.enable = true;
      mpd = {
        enable = true;
        # TODO: Make this more dynamic?
        musicDir = "/home/aether/Music";
        user = "aether";
      };
      geoclue2.enable = true;
    };
  };

  # Doxxing live stream
  time.timeZone = "Europe/Dublin";

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp1s0.useDHCP = true;
  };
}
