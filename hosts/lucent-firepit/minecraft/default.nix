{ config, lib, pkgs, ... }:

with lib;
let
  # https://git.sleeping.town/unascribed/unsup/releases
  unsup = pkgs.fetchurl {
    url = "https://git.sleeping.town/attachments/c521d178-8938-40a5-b21b-0333eef4099e";
    sha256 = "c5bd49784392b651e4bc71fe57976f5b4fb14f09e0e23183ae5b94a821ae4756";
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
    };
    unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats/pack.toml"; };
  };
in {
  config = {
    modules.services.minecraft.enable = true;
    modules.services.minecraft.servers = {
      "gayrats" = import ./gayrats.nix {
        inherit pkgs;

        enable = true;
        server-port = 25565;

        inherit unsup;
        inherit (gayrats) whitelist;

        unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats/pack.toml"; };
      };

      "gayrats-creative" = import ./gayrats-creative.nix {
        inherit pkgs;

        enable = true;
        server-port = 25575;

        inherit unsup;
        inherit (gayrats) whitelist;

        unsupINI = mkUnsupINI { url = "https://oat.zone/f/gayrats-creative/pack.toml"; };
      };

      "n3ko-test" = import ./n3ko-test.nix {
        inherit pkgs;

        enable = true;
        server-port = 25595;
      };

      "wafflecraft" = import ./wafflecraft.nix {
        inherit pkgs;
        inherit lib;

        enable = true;
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

      "modfest-build" = let
        modpack = (pkgs.fetchPackwizModpack rec {
          url = "https://raw.githubusercontent.com/ModFest/modfest-skyandsea/main/pack/pack.toml";
          packHash = "sha256-I+Pqs3q4lI7Qzuot/9RejZhDgaltBxqMfwWsNfLkEVQ=";
          manifestHash = "sha256:0w4b3y95s0jqhjfbzagbilw6fv6zlgzbqnl15kmsgcgb7kxzrzyy";
        });

        mcVersion = "${modpack.manifest.versions.minecraft}";
        serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}-0_15_1";
      in {
        enable = true;
        package = pkgs.fabricServers.${serverVersion};
        jvmOpts = (import ./aikar-flags.nix) "4G";
        
        openFirewall = true;
        
        serverProperties = {
          server-port = 25525;
          gamemode = 1;
          motd = "test server ignore";
          white-list = true;
          max-players = 128;
          allow-flight = true;
          enable-command-block = true;
          enforce-secure-profile = false;
          snooper-enabled = false;
          spawn-protection = 0;
        };

        whitelist = {
          oatmealine = "241d7103-4c9d-4c45-9464-83b5365ce48e";
        };
        
        symlinks = {
          "mods" = "${modpack}/mods";
        };
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
