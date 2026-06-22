{ config, lib, pkgs, ... }:

with lib;
let
  # https://git.sleeping.town/unascribed/unsup/releases
  unsup = pkgs.fetchurl {
    url = "https://git.sleeping.town/unascribed/unsup/releases/download/v1.0/unsup-1.0.jar";
    hash = "sha256-3dmos+eUPqpEYN9jXyKUuB80jvEZ3alAF/U+tprZO8U=";
  };

  mkUnsupINI = { url, extraConfig ? "" }: pkgs.writeTextFile {
    name = "unsup.ini";
    text = ''
      version=1
      preset=minecraft

      source_format=packwiz
      source=${url}

      force_env=server
      no_gui=true
    '' + extraConfig;
  };

  gayrats = {
    whitelist = {
      oatmealine      = "241d7103-4c9d-4c45-9464-83b5365ce48e";
      RustyMyHabibi   = "e20305fa-a44c-44c9-b62e-6918e7c779d6";
      Dj_Afganistan   = "1f879917-1ad4-49c3-9908-90769ee73f85";
      DumbDogDoodles  = "d33e5e3b-85ab-4c93-a61b-605e2673fbe8";
      SuneFoxie       = "82e82ef9-ea17-4794-9051-928b5b8629c1";
      FuzziestRedMoth = "21e1adf8-93f7-4173-a087-b3a9c02edec5";
      hewoicvewse     = "98e715cf-b1a4-4d50-9ed0-7d20fbdf240e";
      numpad_7        = "44e6e6d7-770d-4afc-96b1-9999b61ced1d";
      _Zydra          = "0af7b31f-63a5-426d-8cee-6c54385856b6";
      Arthur_the_AI   = "65332e35-744e-4570-82e5-ab935f68564e";
      DevillishLizzie = "8e884d2e-c22d-43a3-8019-06701434f7a0";
      SqueaksDCorgeh  = "d6d47b60-b1e0-4424-9f57-569a775d62be";
    };
    unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats/pack.toml"; };
  };
in {
  config = {
    modules.services.minecraft.enable = true;
    modules.services.minecraft.servers = {
      "lockout" = import ./lockout.nix {
        inherit pkgs;

        enable = true;
        server-port = 25959;
      };

      "gayrats" = import ./gayrats.nix {
        inherit pkgs;

        enable = false;
        #server-port = 25565; # used by yugoslavia
        server-port = 0;

        inherit unsup;
        inherit (gayrats) whitelist;

        unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats/pack.toml"; };
      };

      "gayrats-creative" = import ./gayrats-creative.nix {
        inherit pkgs;

        enable = false;
        server-port = 25575;

        inherit unsup;
        inherit (gayrats) whitelist;

        unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats-creative/pack.toml"; };
      };

      "gay-capybaras" = import ./gay-capybaras.nix {
        inherit pkgs;

        enable = false;
        server-port = 25505;

        inherit unsup;
        inherit (gayrats) whitelist;

        unsupINI = mkUnsupINI { url = "https://aether.gay/f/gay-capybaras/pack.toml"; };
      };

      "yugoslavia" = {
        enable = false; # never again
        package = pkgs.fabricServers.fabric-1_20_1;
        jvmOpts = ((import ./mc-flags.nix) "8G") + " -javaagent:${unsup}";

        openFirewall = true;

        serverProperties = {
          server-port = 25565;
          gamemode = 0;
          motd = "§bhome of bar";
          white-list = true;
          max-players = 16;
          allow-flight = true;
          simulation-distance = 8;
          entity-broadcast-range-percentage = 50;
          enable-command-block = false;
          enforce-secure-profile = false;
          snooper-enabled = false;
          spawn-protection = 0;
          level-seed = "penis";
          initial-enabled-packs = "bundle";
        };

        symlinks = {
          "unsup.ini" = mkUnsupINI {
            url = "https://yugoslavia.best/packwiz/pack.toml";
          };
        };
      };

      "jaidenaether" = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_5;
        jvmOpts = ((import ./mc-flags.nix) "8G") + " -javaagent:${unsup}";

        openFirewall = true;

        serverProperties = {
          server-port = 25645;
          gamemode = 0;
          white-list = true;
          max-players = 2;
          allow-flight = true;
          simulation-distance = 8;
          enable-command-block = false;
          enforce-secure-profile = false;
          snooper-enabled = false;
          spawn-protection = 0;
          level-seed = "4357816";
        };
      };

      # PLEASE FIX WHATEVER THE *FUCK* IS GOING ON WITH THE PERMISSIONS LATER
      "gay-squirrels" = import ./gay-squirrels.nix {
        inherit pkgs lib unsup;
        inherit (gayrats) whitelist;

        enable = false;
        # enable = false; # I BEG
        server-port = 25969;
        unsupINI = mkUnsupINI { url = "https://aether.gay/f/gay-squirrels/pack.toml"; };
      };

      "smr" = import ./smr.nix {
        inherit pkgs;
        inherit lib;

        enable = false;
        server-port = 25511;

        inherit unsup;
        unsupINI = mkUnsupINI { url = "https://oat.zone/f/smrpack/pack.toml"; };
      };

      "n3ko-test" = import ./n3ko-test.nix {
        inherit pkgs;

        enable = false;
        server-port = 25595;
      };

      "wafflecraft" = import ./wafflecraft.nix {
        inherit pkgs;
        inherit lib;

        enable = false;
        server-port = 25535;

        inherit unsup;
        unsupINI = mkUnsupINI {
          url = "https://oat.zone/f/wafflecraft/pack.toml";
          extraConfig = ''
            [flavors]
            shaders=no_shaders
            minimap=no_minimap
            barrel_roll=no_barrel_roll
          '';
        };
      };

      "minehattan" = import ./minehattan.nix {
        inherit pkgs;
        inherit lib;

        enable = false;
        server-port = 25984;
      };

      "upsilon" = import ./upsilon.nix {
        inherit pkgs;
        inherit lib;
        inherit unsup;

        enable = false;
        server-port = 25525;
      };
    };

    systemd.services.minecraft-server-dark-firepit.serviceConfig = {
      # packwiz workaround
      # https://github.com/Infinidoge/nix-minecraft/issues/12#issuecomment-1235999072
      # TODO: this doesn't work!!! it just goes "error code 1" and refuses to elaborate
      #ExecStartPre = [
      #  ''cd "/srv/minecraft/dark-firepit"; nix-shell -p adoptopenjdk-hotspot-bin-16 --run "java -jar /srv/minecraft/dark-firepit/packwiz-installer-bootstrap.jar -g 'https://dark-firepit.oat.zone/Fire Pit 1.19.2/pack.toml'"''
      #];
    };
  };
}
