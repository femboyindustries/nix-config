{ config, lib, pkgs, ... }:

with lib;
let
  darkFirepitWhitelist = {
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
in {
  config = {
    modules.services.minecraft = {
      enable = true;
      servers = {
        "dark-firepit" = {
          enable = false;
          #autoStart = false;
          openFirewall = true;
          serverProperties = {
            server-port = 25565;
            gamemode = 0;
            motd = "dark-firepit, 1.19.2 Fabric";
            white-list = true;
            max-players = 8;
            allow-flight = true;
            enable-command-block = true;
            enforce-secure-profile = false;
            level-type = "terra:overworld/overworld";
            snooper-enabled = false;
            spawn-protection = 0;
          };
          whitelist = darkFirepitWhitelist;
          package = pkgs.minecraftServers.fabric-1_19_2;
          jvmOpts = "-Xmx6G";
        };
        "gayrats" = let
          packURL = "https://oat.zone/f/gayrats/pack.toml";

          # https://git.sleeping.town/unascribed/unsup/releases
          unsup = pkgs.fetchurl {
            url = "https://git.sleeping.town/attachments/c521d178-8938-40a5-b21b-0333eef4099e";
            sha256 = "c5bd49784392b651e4bc71fe57976f5b4fb14f09e0e23183ae5b94a821ae4756";
          };
          unsupIni = ''
            version=1
            preset=minecraft

            source_format=packwiz
            source=${packURL}

            force_env=server
            no_gui=true
          '';
        in {
          enable = true;
          autoStart = true;
          openFirewall = true;
          serverProperties = {
            server-port = 25565;
            gamemode = 0;
            motd = "dark-firepit, 1.19.2 Fabric";
            white-list = true;
            max-players = 8;
            allow-flight = true;
            enable-command-block = true;
            enforce-secure-profile = false;
            snooper-enabled = false;
            spawn-protection = 0;
          };
          symlinks = {
            "unsup.ini" = pkgs.writeTextFile {
              name = "unsup.ini";
              text = unsupIni;
            };
          };
          whitelist = darkFirepitWhitelist;
          package = pkgs.minecraftServers.fabric-1_19_2;
          jvmOpts = "-Xmx6G -javaagent:${unsup}";
        };
        "n3ko-test" = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          serverProperties = {
            server-port = 25595;
            gamemode = 1;
            motd = "N3KO SMP Testing server";
            white-list = true;
            max-players = 8;
            allow-flight = true;
            enable-command-block = true;
            enforce-secure-profile = false;
            #level-type = "terra:overworld/overworld";
            snooper-enabled = false;
            spawn-protection = 0;
          };
          whitelist = {
            oatmealine  = "241d7103-4c9d-4c45-9464-83b5365ce48e";
            Cardboxneko = "3d406152-008c-4ec9-bf49-44c883baca6d";
          };
          package = pkgs.fabricServers.fabric-1_18_2;
          jvmOpts = "-Xmx4G";
        };
        "wafflecraft" = let
          packURL = "https://oat.zone/f/wafflecraft/pack.toml";

          # https://git.sleeping.town/unascribed/unsup/releases
          unsup = pkgs.fetchurl {
            url = "https://git.sleeping.town/attachments/c521d178-8938-40a5-b21b-0333eef4099e";
            sha256 = "c5bd49784392b651e4bc71fe57976f5b4fb14f09e0e23183ae5b94a821ae4756";
          };
          unsupIni = ''
            version=1
            preset=minecraft

            source_format=packwiz
            source=${packURL}

            force_env=server
            no_gui=true

            [flavors]
            shaders=no_shaders
            minimap=no_minimap
            barrel_roll=no_barrel_roll
          '';
        in {
          enable = true;
          autoStart = true;
          openFirewall = true;
          serverProperties = {
            server-port = 25535;
            gamemode = "survival";
            motd = "wafflecraft Real";
            max-players = 32;
            allow-flight = true;
            enable-command-block = false;
            enforce-secure-profile = false;
            snooper-enabled = false;
            spawn-protection = 0;
            white-list = true;
            view-distance = 16;
          };
          whitelist = {
            oatmealine =     "241d7103-4c9d-4c45-9464-83b5365ce48e";
            plightshift =    "de87f3e6-d44f-40af-8bff-48828694b616";
            mangoafterdawn = "840ad485-1060-4bcf-8730-c552e5c8d62a";
            drazilspirits =  "1d912f45-978b-4edc-b026-26bd5ed6ce31";
            segaskullll =    "e6d510e6-a1d3-4801-8a5e-52d2c75b2446";
            Tetaes =         "4b149260-d56e-4835-b3f6-2dce173a92a5";
            sorae_ =         "9639d272-4c20-459d-adea-4aa89ee3cdc1";
            GelloISMello =   "a2883a99-fe5d-454d-98b9-d65e4cec7e7e";
            Triplejy2k =     "dced0fad-3802-4544-aaad-64d8fd12b1e8";
            RAKKIIsan =      "0706e583-82e3-478c-8769-1131fb9aef5d";
            CyberBlue =      "151bea19-3d16-45eb-8ae3-3057cde8e8f4";
            numpad_7 =       "44e6e6d7-770d-4afc-96b1-9999b61ced1d";
            CERiNG =         "8dd710ce-fd30-45a5-9252-739d3c03df19";
            electr1ca =      "c18dcc3b-6c11-42e9-b7d8-4b458ea7017d";
            bigboyty69 =     "ed735421-c22b-467a-9eac-5c08437ea3e8";
          };
          symlinks = {
            "unsup.ini" = pkgs.writeTextFile {
              name = "unsup.ini";
              text = unsupIni;
            };
          };
          # this is UGLY as FUCK; but unfortunately https://github.com/Infinidoge/nix-minecraft/issues/15
          package = pkgs.jdk17;
          jvmOpts = "-Xmx6G -javaagent:${unsup} "
            + lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/wafflecraft/libraries/net/minecraftforge/forge/1.18.2-40.2.1/unix_args.txt");
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
