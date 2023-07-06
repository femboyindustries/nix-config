{ pkgs, inputs, lib, ... }:

let
  keys = import ./authorizedKeys.nix;
  fetchSSH = (host: lib._.getSSH host keys);
  fetchSSHKeys = map fetchSSH;

  agenixPkg = inputs.agenix.packages.${pkgs.system}.default;
in {
  imports = [
    ./hardware-configuration.nix
    ./minecraft
    ./srb2k.nix
    ./yugoslavia-best.nix
    ./webapps/default.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    #inputs.watch-party.nixosModules.watch-party
    inputs.cohost-blogger.nixosModules.cohost-blogger
    inputs.vscode-server.nixosModules.default
  ];

  services.vscode-server.enable = true;

  user = {
    packages = with pkgs; [
      git
      curl
    ];
  };

  users.groups.dotfiles = {};
  users.groups.yugoslavia = {};

  # TODO: temporary fix; please find root cause. i'm begging you
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];

  normalUsers = {
    # aether??? is that... reference.../.??? aether https://www.curseforge.com/minecraft/mc-mods/aether mod  Curseforge minecraft Forge Patreon Chat twitter code license Assets license All rights reserved categories Last Updated apr 17 2021 Game Version 1.12.2 aether
    aether = {
      conf = {
        packages = with pkgs; [ bat duf broot helix nil ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "aether@subsurface"
          "aether@phone"
          "aether@Aethers-Mini.station"
        ];
      };

      homeConf.home = {
        sessionVariables = {
          EDITOR = "hx";
          NIX_REMOTE = "daemon";
        };
      };
    };

    # oatmealine ?? is that a reference to jill oatmealine monoids from the beloved videogame franchise "oateamelin jill monoids???" .oat. zone??? from va11hall-a??? video game???? woman????? minecraft???????
    oatmealine = {
      conf = {
        packages = with pkgs; [ bat tmux micro direnv nix-direnv ripgrep agenixPkg ];
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
          #EDITOR = lib.trace (lib.readFile age.secrets.huge-furry-cock.path) "micro";
          EDITOR = "micro";
          NIX_REMOTE = "daemon";
        };
      };
    };
    # i yearn for the day this name ceases to mean
    mayflower = {
      conf = {
        packages = with pkgs; [ micro tmux ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" "yugoslavia" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "mayflower@BMW-M550d-xDrive"
          "swag@BMW-M550d-xDrive"
        ];
      };

      homeConf.home = {
        sessionVariables = {
          EDITOR = "micro";
          NIX_REMOTE = "daemon";
        };
      };
    };

    #winter = {
    #  conf = {
    #    packages = with pkgs; [ micro ];
    #    shell = pkgs.unstable.fish;
    #    extraGroups = [ "wheel" "nix-users" "dotfiles" ];
    #    initialHashedPassword = "!";
    #    openssh.authorizedKeys.keys = fetchSSHKeys [
    #      "lilith@bms-cab"
    #    ];
    #  };
    #};
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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBKMXTLBJ5iIPiO9jiN+AHWxpgG1kcdI0h23+G1FLMnK+xhkmaP9Vjr9QbqQ4mmRqfGERfJW5H2/OvTEUXnrkAp1Jc8oPrc14/auwKivtbMC5tsWzioDMbcAYKrcP37D3Kw1P7nzSyAz3QsRXBRx26OE5NeTo4YfGl/TOkQnoBCDTt8kcziWEvUVeOgnHf3hnszs2H4P6RAyOqjuOH6BWhtbKsCHThTHaAadLgeH5nB1WXLYqG2N1KEzAhj8WBBzPmeZcMMRr5xkqYVj14cd+9syEaenV+wXapoPyDtOb6YtOKArN9RkT0OOqQk17OzxvGqHUEXQ4eGmNgc8BLsGJn rsa-key-20230402"
        #fetchSSH "oatmealine@void-defragmented"
        #fetchSSH "oatmealine@beppy-phone"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAIphRdy+g7zfj+KxfONoD24lzk+/mGhQ0EnOe8QGf8 oatmealine@disroot.org" # gh actions
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

      mosh = {
        enable = true;
      };

      wireguard = {
        enable = true;
        server = true;
        externalInterface = "eno1";
        interfaces."wg0" = import ./wireguardInterface.nix;
      };

      terraria = {
        enable = false;
        port = 7777; # port-forwarded
        messageOfTheDay = "hi";
        openFirewall = true;
        worldPath = "/var/lib/terraria/gbj.wld";
        autoCreatedWorldSize = "large";
        dataDir = "/var/lib/terraria";
      };

      jmusicbot = let
        baseOptions = {
          owner = 276416332894044160;
          game = "Listening to your heartbeat :heart";
          status = "ONLINE";
          songinstatus = true;

          success = "<:observer:1004408859831586907>";
          warning = "<:slugclose:1000202980403974144>";
          error = "🚫!!!!! 🚫🚫🚫 >:((((";
          loading = "<:handsl:966010145698086993><:handsr:966010145886830692>";
          searching = "<:scripulous_fingore_point:1012777703323222087><:scripulous_fingore:1012777704455667754>";

          npimages = true;
          stayinchannel = true;

          aliases = {
            nowplaying = [ "np" "current" ];
            play = [ "p" ];
            queue = [ "list" "q" ];
            remove = [ "delete" "d" ];
            skip = [ "s" ];
            forceskip = [ "fs" ];
            movetrack = [ "move" "m" ];
          };
          
          queuetype = "REGULAR";
        };
      in {
        enable = true;
        instances = {
          "jomble" = {
            enable = true;
            package = pkgs._.gmusicbot;

            options = baseOptions // {
              token = lib.removeSuffix "\n" (builtins.readFile /etc/jomble_token);
              prefix = ";";
            };
          };
          "jillo" = {
            enable = true;
            package = pkgs._.gmusicbot;
            
            options = baseOptions // {
              token = lib.removeSuffix "\n" (builtins.readFile /etc/jillo_token);
              prefix = ":";
            };
          };
        };
      };
    };
  };

  programs.fish.enable = true;

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

    # temporarily disabled
#    enableIPv6 = true;

    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      ipv4.addresses = [{
        address = "46.4.96.113";
#        prefixLength = 27;
        prefixLength = 24;
      }];

/*
      ipv6.addresses = [{
        address =  "2a01:4f8:140::1";
        prefixLength = 64;
      }];
*/
    };

    defaultGateway = "46.4.96.97";
/*
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
*/
    nameservers = [ "8.8.8.8" "1.1.1.1" ];

    firewall.allowPing = true;
    # minecraft proximity voice chat
    firewall.allowedTCPPorts = [ 24454 24464 25567 25577 4499 21025 ];
    firewall.allowedUDPPorts = [ 24454 24464 25567 25577 4499 21025 ];
  };

#  environment.etc."dhcpcd.duid".text = "d0:50:99:d4:04:68:d0:50:99:d4:04:68";
}
