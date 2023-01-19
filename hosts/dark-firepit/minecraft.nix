{ config, lib, pkgs, ... }:

with lib;
let
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
          whitelist = {
            oatmealine      = "241d7103-4c9d-4c45-9464-83b5365ce48e";
            RustyMyHabibi   = "e20305fa-a44c-44c9-b62e-6918e7c779d6";
            Dj_Afganistan   = "1f879917-1ad4-49c3-9908-90769ee73f85";
            DumbDogDoodles  = "d33e5e3b-85ab-4c93-a61b-605e2673fbe8";
            SuneFoxie       = "82e82ef9-ea17-4794-9051-928b5b8629c1";
            FuzziestRedMoth = "21e1adf8-93f7-4173-a087-b3a9c02edec5";
          };
          package = pkgs.minecraftServers.fabric-1_19_2;
          jvmOpts = "-Xmx6G";
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
        "gbj" = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          serverProperties = {
            server-port = 25585;
            gamemode = 0;
            motd = "gay baby jail";
            max-players = 16;
            allow-flight = true;
            enable-command-block = true;
            enforce-secure-profile = false;
            snooper-enabled = false;
            spawn-protection = 0;
            level-type = "terra:overworld/overworld";
            white-list = true;
            view-distance = 32;
          };
          whitelist = {
            UnderSunandSky = "b788f46e-50a2-4af3-a668-15ae393c59d8";
            PianoBoyBenini = "042d6cef-6194-46b4-9bfc-87b3c4cdf94a";
            oatmealine =     "241d7103-4c9d-4c45-9464-83b5365ce48e";
            Starblazerz128 = "d45eb172-8360-42fd-a185-ab2197b71f9a";
            Chevreau =       "b594ba84-f10c-42ff-83a6-8046f90ad0b8";
            Yarn01 =         "40fee73f-d4b3-47c6-adf7-fe7c717a1f55";
            "1C3doggo" =     "48c3a077-9e3b-47a6-b17b-4ed0b1bc33b2";
            CosmicCats =     "32148b79-12a8-48f1-b158-3c97c45e39e5";
            m3bo =           "6e33434c-1ec0-4c69-9dad-b32b1197496e";
            SomewhatSyl =    "d8bac1ef-27d5-4c94-a9e7-e2d079edef22";
            Nightmare_Tank = "92840daa-823e-4b8e-9741-be296147e823";
            JDavisBro =      "e8529c4b-701e-46c5-a8d7-0dfb0e0b642d";
            Ironic_queen =   "443fe20d-77e0-4a4a-8bb7-a4b9ad654550";
            azurehaiku =     "fd7aba33-4307-4eba-aa63-70bc3e38a2d7";
            TryHardGamerTV = "8273b84d-a687-49fb-98de-a3e626e26c3b";
            "_AtlasFox_" =   "0ce1bbe0-ea57-463c-8df3-4c046dc6eff2";
          };
          package = pkgs.minecraftServers.fabric-1_19_2;
          jvmOpts = "-Xmx4G";
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
