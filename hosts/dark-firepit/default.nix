{ pkgs, inputs, lib, ... }:

let
  keys = import ./authorizedKeys.nix;
  fetchSSH = (host: lib._.getSSH host keys);
  fetchSSHKeys = map fetchSSH;
in {
  imports = [
    ./hardware-configuration.nix
    ./yugoslavia-best.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    #inputs.watch-party.nixosModules.watch-party
    (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
  ];

#  services.auto-fix-vscode-server.enable = true;
  services.vscode-server.enable = true;

  user = {
    packages = with pkgs; [
      git
      curl
    ];
  };

  users.groups.dotfiles = {};
  users.groups.yugoslavia = {};

  normalUsers = {
    # aether??? is that... reference.../.??? aether https://www.curseforge.com/minecraft/mc-mods/aether mod  Curseforge minecraft Forge Patreon Chat twitter code license Assets license All rights reserved categories Last Updated apr 17 2021 Game Version 1.12.2 aether
    aether = {
      conf = {
        packages = with pkgs; [ bat duf broot nftables tmux bottom ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "aether@subsurface"
          "aether@phone"
        ];
      };

      homeConf.home = {
        sessionVariables = {
          EDITOR = "nvim";
          NIX_REMOTE = "daemon";
        };
      };
    };

    # oatmealine ?? is that a reference to jill oatmealine monoids from the beloved videogame franchise "oateamelin jill monoids???" .oat. zone??? from va11hall-a??? video game???? woman????? minecraft???????
    oatmealine = {
      conf = {
        packages = with pkgs; [ bat tmux micro direnv nix-direnv ripgrep _.glitch-soc ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" "yugoslavia" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "oatmealine@void-defragmented"
          "oatmealine@beppy-phone"
        ];
      };

      homeConf.home = {
        sessionVariables = {
          EDITOR = "micro";
          NIX_REMOTE = "daemon";
        };
      };
    };

    mayflower = {
      conf = {
        packages = with pkgs; [ micro tmux ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" "yugoslavia" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "mayflower@BMW-M550d-xDrive"
        ];
      };

      homeConf.home = {
        sessionVariables = {
          EDITOR = "micro";
          NIX_REMOTE = "daemon";
        };
      };
    };
  };

  keyboard = {
    locale = "en_US.UTF-8";
    variant = "qwerty";
  };

  modules = {
    shell.fish.enable = true;
    security.isLocalMachine = false;
    editors.neovim.enable = true;
    remote = {
      enable = true;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAoV7ymOtfC8SYvv31/GGso8DoHKE/KOfoEZ0hjmYtaQg7dyi5ijfDikLZUux8aWivvRofa7SqyaK0Ea+s9KuTX/dreJKz/RKG+QHLjw6U0FSoJ765q56pUy0j0TZoVy4PjSb38of56urg1UmHkK13WQXrvjwdHUjAcVx6PurHAxsbmxhYkJO9Jmvr8CB+PZFKIHjewkgBWkBxD97WFNwDfmBmvh1F5xRn8WhgT+2DVdQ2coN4Eqwc4NWzBUSfrro0gARsJsUvQxdx8f1kJDQKy2lQWCnlgRiD+pK5ocf1wCZfJMs0NQ6xqCZDKDJTcyGNLWH/L57Pg5U5t7BWRTTPmQ== yugoslavia"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCX2uRTaL1Nu4KzsSJSVc7R2yCIa4Mw3KuJAMluQO746eXBFeTmRN6Pqc+H0Rpz9nkQ/fB8tYl70FfrYy4suM0QCY1IDbPWaUBmLQYCt6nzCfFY8PTpLoJmeQW3jzG7VqSjjl+uG2KLQqPtzxmvukIJRovhrKcUnPzw4tU4BLy2uGWgJN9sGofWczmtxdijADyOYtasVIr6/Hca5IwMCldbqQ9B1k+VIE87Kv2k5n+LVRVMsVHaVSubIMYZFbZFDW2/oRVg2ainewO0e9XPbtBREVraPnuf7s4uBByk4goQfLhz3B6L4JLbYYijw25+SmeJcesDxJUIIKMCuZChNcyb aura@LAPTOP-MEN8UH6Q"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRI9sGl0EmOkNNnh8SgRq197gkEy3XEwKZjLIr27V9PfaVOLIAcZiGcOa5q7rc5FjcCtkQ9+/twE24bZpxkK0ygrRJBEdT+HGAUmpY/kRPEn/tqjmwNu43vQqOhNSYmAAzdjJ4AuRPK5st8QQyOzKv5Pnghwy8xPAjOM3o4n9ULMLjVvAu0eTmCJMKxEvz5FUEIVZtEid/ng46k/bJ/njSh8vyGBQV4fJei6M9Ovw0HPqqzWyV/e0c3hTClG4dfLCK3Qv3hLhXQ+8I9iaL7D2wZdr3F2lbg0vS/QctPZc28f1gpkFEzVflEzAk4aFwJMMflY04IG1Dr44IfM1gJbpj rsa-key-20220423"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCL75/Pg5bP7LaXE6uPyyv8QDRivWJC6YcH6oJJztkjqL6g+0xPPiN6I54q/bNF4nHA2BHVUktKUU9bGDEOpYIRq7kegp2/K/+FNTM1Kz6rJSrSc8e0Ogxg8vhD6maxqLU8q+D1OMhBu0UiWUB+GxXmeYfBtXPjpcE+AaJ80BPs7vwiulHPGn7UAcRuP36Z+3JJiN2BQnU2aizXWsgyU575Uy3DVvAt7eHon+SoJiTCs2//5KexJ42U6ZiE6f/oTFdiud70lpxhGgiiFvj6M9RZ0aLoxspiskW45jKLXIMJ+mO6husg9GfvCchbps3YkmH0hZ24Ii1EiFhi5HZMY0Lt mayflower"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrlqH2OShvXdzq1sV5IDuWQzeC9OHBVvwj0+Y0XXwi7 mayflower-thinkpad"
        #fetchSSH "oatmealine@void-defragmented"
        #fetchSSH "oatmealine@beppy-phone"
      ];
      packages = with pkgs; [ tmux micro ];
      shell = pkgs.unstable.fish;
    };
    services = {
      ssh = {
        enable = true;
        requirePassword = false;
      };

      postgres.enable = true;

      nextcloud = {
        enable = true;
        domain = "nextcloud.dark-firepit.cloud";
      };

      gitea = {
        enable = true;
        domain = "git.oat.zone";
        port = 3000;
      };

      matrix.conduit = {
        enable = false;
        domain = "matrix.dark-firepit.cloud";
      };

      srb2k = with lib; with builtins; let
        addonDir = "/var/lib/srb2k/firepit/";
        fileNames = attrNames (readDir (/. + addonDir));
        addonFileNames = filter (n: hasSuffix ".lua" n || hasSuffix ".kart" n || hasSuffix ".pk3" n || hasSuffix ".wad" n) fileNames;        
        colors = builtins.fromJSON ''{
          "white": "\u0080",
          "purple": "\u0081",
          "yellow": "\u0082",
          "green": "\u0083",
          "blue": "\u0084",
          "red": "\u0085",
          "gray": "\u0086",
          "orange": "\u0087",
          "cyan": "\u0088",
          "lavender": "\u0089",
          "gold": "\u008a",
          "lime": "\u008b",
          "steel": "\u008c",
          "pink": "\u008d",
          "brown": "\u008e",
          "peach": "\u008f"
        }'';
        colorsLua = {
          white = "\\128";
          purple = "\\129";
          yellow = "\\130";
          green = "\\131";
          blue = "\\132";
          red = "\\133";
          gray = "\\134";
          orange = "\\135";
          cyan = "\\136";
          lavender = "\\137";
          gold = "\\138";
          lime = "\\139";
          steel = "\\140";
          pink = "\\141";
          brown = "\\142";
          peach = "\\143";
        };
      in {
        enable = true;
        advertise = true;
        addons = map (n: "${addonDir}${n}") addonFileNames;
        config = {
          maxplayers = 16;
          http_source = "https://yugoslavia.best/srb2kaddons/";
          maxsend = "max";
          servername = with colors; "${white}[${cyan}EU${white}] ${lime}yugoslavia.best";
          server_contact = "oat.zone||home of bar";
        };
        serv = with colorsLua; ''
          kmp_hardsneakers on
          kmp_extendflashtics on
          kmp_floatingitemfuse on
          kmp_hyudoro on
          kmp_haste on
          kmp_respawnpoints on
          kmp_battleaccel on
          maxsend max
          fr_enabled off
          khaos enable off

          wait 1

          fd_finishkill off
          fd_hitkill off

          wait 1

          nametag_star on

          wait 1

          hm_bail on
          hm_timelimit 8
          hm_motd on
          hm_motd_nag on
          hm_motd_name "${lime}yugoslavia.best"
          hm_motd_tagline "home of bar"
          hm_motd_contact "oat.zone"
          hm_restat on
          hm_restat_notify on
          hm_votable exitlevel
          hm_vote_timer 20

          wait 1

          hm_specbomb on

          hm_scoreboard on
          hm_scoreboard_humor on
          wait 1
          hm_scoreboard_addline "${lime}yugoslavia.best${white}: home of bar"
          wait 1
          hm_scoreboard_addline "  hosted by ${lime}oat.zone"
          wait 1
          hm_scoreboard_addline "casual server, anything goes,"
          hm_scoreboard_addline "feel free to suggest mods to"
          wait 1
          hm_scoreboard_addline "${pink}oatmealine#5397 ${white}/ ${pink}oatmealine@disroot.org"
          //hm_scoreboard_addline "${white}80${purple}81${yellow}82${green}83${blue}84${red}85${gray}86${orange}87${cyan}88${lavender}89${gold}8a${lime}8b${steel}8c${pink}8d${brown}8e${peach}8f"

          wait 1

          hf_displaymode 3
        ''; #"
      };

      minecraft = {
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
            };
            package = pkgs.minecraftServers.fabric-1_19_2;
            jvmOpts = "-Xmx4G";
          };
        };
      };

      glitch-soc = {
        enable = true;
        domain = "feditest.oat.zone";
      };

      wireguard = {
        enable = true;
        server = true;
        externalInterface = "eno1";
        interfaces."wg0" = import ./wireguardInterface.nix;
      };

      vaultwarden = {
        enable = true;
        domain = "vault.aether.gay";
      };

      jillo = {
        enable = false;
        dataDir = "/var/lib/jillo";
      };

      # not entirely necessary but makes it so that invalid domains and/or direct ip access aborts connection
      # prevents other domains from "stealing" content by settings their dns to our ip
      # this has happened before by the way on the vps. i have no clue how or why
      # update: also optimizes gzip and tls stuff
      nginx-config = {
        enable = true;
      };

      staticSites = {
        "aether.gay".dataDir = "/var/www/aether.gay";
        "dark-firepit.dev".dataDir = "/var/www/dark-firepit.dev";
        #"dark-firepit.oat.zone".dataDir = "/var/www/dark-firepit.oat.zone";
        "va11halla.oat.zone".dataDir = "/var/www/va11halla.oat.zone";
        "giger.yugoslavia.fishing".dataDir = "/var/www/giger.yugoslavia.fishing";
        "modfiles.oat.zone".dataDir = "/var/www/modfiles.oat.zone";
        "shop.yugoslavia.best".dataDir = "/var/www/shop.yugoslavia.best";
        "tesco-underground-dev.oat.zone".dataDir = "/var/www/tesco-underground-dev.oat.zone";
        "tesco-underground-dev.oat.zone".auth = { tesco = builtins.readFile /etc/tesco; };
        "oat.zone".dataDir = "/var/www/oat.zone";
        "oat.zone".php = true;
        "yugoslavia.fishing".dataDir = "/var/www/yugoslavia.fishing";
        "yugoslavia.fishing".php = true;
        "educationmath.oat.zone".dataDir = "/var/www/proxy.oat.zone";
        "educationmath.oat.zone".php = true;
        "educationmath.oat.zone".auth = { twh = builtins.readFile /etc/proxy_twh; };
        "rivervalleychocolate.com".dataDir = "/var/www/rivervalleychocolate.com";
        "rivervalleychocolate.com".php = true;
        "tac.yugoslavia.best".dataDir = "/var/www/tac.yugoslavia.best/public";
        "tac.yugoslavia.best".php = true;
        "tac.yugoslavia.best".phpHandlePathing = true;
        "pjsk.oat.zone".dataDir = "/var/www/pjsk.oat.zone";
        "mayf.pink".dataDir = "/var/www/mayf.pink/public";
        "mayf.pink".php = true;
        "mayf.pink".phpHandlePathing = true;
      };

      nitter = {
        enable = true;
        lightweight = false; # enable if shit gets wild; check config for more info
        port = 3005;
        domain = "nitter.oat.zone";
      };

      #watch-party = {
      #  enable = true;
      #  port = 1984;
      #};

      terraria = {
        enable = false;
        port = 7777; # port-forwarded
        messageOfTheDay = "hi";
        openFirewall = true;
        worldPath = "/var/lib/terraria/gbj.wld";
        autoCreatedWorldSize = "large";
        dataDir = "/var/lib/terraria";
      };

      matomo = {
        enable = true;
      };

      isso = {
        enable = true;
        port = 1995;
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

  services.nginx.virtualHosts."oat.zone" = {
    locations."/f/".extraConfig = ''
      add_header Access-Control-Allow-Origin "*";
    '';
  };

  # https://www.edwinwenink.xyz/posts/47-tilde_server/
  services.nginx.virtualHosts."dark-firepit.dev" = {
    locations."~ ^/~([^/\\s]+?)(/[^\\s]*)?$".extraConfig = ''
      add_header X-debug-message "/home/$1/www$2" always;
      alias /home/$1/www$2;
      index index.html index.htm;
      autoindex on;
    '';
  };

  services.nginx.virtualHosts."nitter.oat.zone" = {
    locations."/".extraConfig = ''
      if ($http_user_agent = 'Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)') {
        return 302 $scheme://fxtwitter.com$request_uri;
      }
    '';
  };

  security.doas = {
    extraRules = [
      { users = [ "aether" ]; noPass = false; persist = true; keepEnv = true; }
      { users = [ "oatmealine" ]; noPass = true; persist = false; keepEnv = true; }
    ];
  };

  time.timeZone = "Europe/Amsterdam";

# If you uncomment this, I will uncomment the spores in your body
# mmm spores ymmnu.uyyy.., :)
  networking.useDHCP = false;

  networking = {
    # for docs, start here
    # https://nixos.org/manual/nixos/stable/options.html#opt-networking.enableB43Firmware

    enableIPv6 = true; # true by default, but better safe than sorry

    interfaces.eno1.ipv4.addresses = [
      { address = "51.89.98.8";
        prefixLength = 24;
      }
    ];

    defaultGateway = "51.89.98.254";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];

    interfaces.eno1.ipv6.addresses = [
      { address = "2001:41d0:0700:3308::";
        prefixLength = 64;
      }

      { address = "2001:41d0:0700:33ff::";
        prefixLength = 64;
      }
    ];

    defaultGateway6 = {
      address = "2001:41d0:0700:33ff:00ff:00ff:00ff:00ff";
#      address = "33ff::1";
#      address = "2001::1";
      interface = "eno1";
    };

    firewall.allowPing = true;
    # minecraft proximity voice chat
    firewall.allowedTCPPorts = [ 24454 25567 ];
    firewall.allowedUDPPorts = [ 24454 25567 ];
  };

#  environment.etc."dhcpcd.duid".text = "d0:50:99:d4:04:68:d0:50:99:d4:04:68";
}
