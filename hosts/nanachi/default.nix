{ pkgs, inputs, lib, ... }:

let
  keys = import ./authorizedKeys.nix;
  fetchSSH = (host: lib._.getSSH host keys);
  fetchSSHKeys = map fetchSSH;
in {
  imports = [
    ./hardware-configuration.nix
    #./minecraft
    ./srb2k.nix
    ./yugoslavia-best.nix
    ./webapps/default.nix
    inputs.post-cohost-blogger.nixosModules.cohost-blogger
    inputs.nlw-api.nixosModules.nlw-api
    inputs.cardgen.nixosModules.cardgen
    inputs.gd-icon-renderer-web.nixosModules.default
    inputs.following-shim.nixosModules.following-shim
  ];

  services.logrotate.checkConfig = false;

  users.groups.dotfiles = {};
  users.groups.yugoslavia = {};

  normalUsers = {
    # oatmealine ?? is that a reference to jill oatmealine monoids from the beloved videogame franchise "oateamelin jill monoids???" .oat. zone??? from va11hall-a??? video game???? woman????? minecraft???????
    oatmealine = {
      conf = {
        packages = with pkgs; [ bat tmux micro direnv nix-direnv ripgrep htop unzip zip ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" "yugoslavia" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [
          "oatmealine@five-pebbles"
          "oatmealine@boykisser"
          "oatmealine@seven-red-suns"
          "oatmealine@gazing-stars"
        ];
      };

      homeConf.home.sessionVariables.EDITOR = "micro";
      homeConf.home.sessionVariables.NIX_REMOTE = "daemon";
    };

    # i yearn for the day this name ceases to mean
    # boy what the FUCK were you cooking with this
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

      homeConf.home.sessionVariables.EDITOR = "micro";
      homeConf.home.sessionVariables.NIX_REMOTE = "daemon";
    };

    zydra = {
      conf = {
        packages = with pkgs; [ micro tmux ];
        shell = pkgs.unstable.fish;
        extraGroups = [ "wheel" "nix-users" "dotfiles" ];
        initialHashedPassword = "!";
        openssh.authorizedKeys.keys = fetchSSHKeys [ "zydra@thedragon" "zydra@overlord" ];
      };

      homeConf.home.sessionVariables.EDITOR = "micro";
      homeConf.home.sessionVariables.NIX_REMOTE = "daemon";
    };
  };

  security.acme.certs."at.yugoslavia.best" = {
    extraDomainNames = [ "*.at.yugoslavia.best" ];
    dnsPropagationCheck = true;

    # https://go-acme.github.io/lego/dns/cloudflare/index.html
    dnsProvider = "cloudflare";
    credentialFiles = {
      CLOUDFLARE_DNS_API_TOKEN_FILE = "/etc/yugoslavia.best-cloudflare-secret";
    };
  };

  modules = {
    shell.fish.enable = true;
    security.isLocalMachine = false;
    remote = {
      enable = true;
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAoV7ymOtfC8SYvv31/GGso8DoHKE/KOfoEZ0hjmYtaQg7dyi5ijfDikLZUux8aWivvRofa7SqyaK0Ea+s9KuTX/dreJKz/RKG+QHLjw6U0FSoJ765q56pUy0j0TZoVy4PjSb38of56urg1UmHkK13WQXrvjwdHUjAcVx6PurHAxsbmxhYkJO9Jmvr8CB+PZFKIHjewkgBWkBxD97WFNwDfmBmvh1F5xRn8WhgT+2DVdQ2coN4Eqwc4NWzBUSfrro0gARsJsUvQxdx8f1kJDQKy2lQWCnlgRiD+pK5ocf1wCZfJMs0NQ6xqCZDKDJTcyGNLWH/L57Pg5U5t7BWRTTPmQ== yugoslavia"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRI9sGl0EmOkNNnh8SgRq197gkEy3XEwKZjLIr27V9PfaVOLIAcZiGcOa5q7rc5FjcCtkQ9+/twE24bZpxkK0ygrRJBEdT+HGAUmpY/kRPEn/tqjmwNu43vQqOhNSYmAAzdjJ4AuRPK5st8QQyOzKv5Pnghwy8xPAjOM3o4n9ULMLjVvAu0eTmCJMKxEvz5FUEIVZtEid/ng46k/bJ/njSh8vyGBQV4fJei6M9Ovw0HPqqzWyV/e0c3hTClG4dfLCK3Qv3hLhXQ+8I9iaL7D2wZdr3F2lbg0vS/QctPZc28f1gpkFEzVflEzAk4aFwJMMflY04IG1Dr44IfM1gJbpj rsa-key-20220423"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCL75/Pg5bP7LaXE6uPyyv8QDRivWJC6YcH6oJJztkjqL6g+0xPPiN6I54q/bNF4nHA2BHVUktKUU9bGDEOpYIRq7kegp2/K/+FNTM1Kz6rJSrSc8e0Ogxg8vhD6maxqLU8q+D1OMhBu0UiWUB+GxXmeYfBtXPjpcE+AaJ80BPs7vwiulHPGn7UAcRuP36Z+3JJiN2BQnU2aizXWsgyU575Uy3DVvAt7eHon+SoJiTCs2//5KexJ42U6ZiE6f/oTFdiud70lpxhGgiiFvj6M9RZ0aLoxspiskW45jKLXIMJ+mO6husg9GfvCchbps3YkmH0hZ24Ii1EiFhi5HZMY0Lt mayflower"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrlqH2OShvXdzq1sV5IDuWQzeC9OHBVvwj0+Y0XXwi7 mayflower-thinkpad"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBKMXTLBJ5iIPiO9jiN+AHWxpgG1kcdI0h23+G1FLMnK+xhkmaP9Vjr9QbqQ4mmRqfGERfJW5H2/OvTEUXnrkAp1Jc8oPrc14/auwKivtbMC5tsWzioDMbcAYKrcP37D3Kw1P7nzSyAz3QsRXBRx26OE5NeTo4YfGl/TOkQnoBCDTt8kcziWEvUVeOgnHf3hnszs2H4P6RAyOqjuOH6BWhtbKsCHThTHaAadLgeH5nB1WXLYqG2N1KEzAhj8WBBzPmeZcMMRr5xkqYVj14cd+9syEaenV+wXapoPyDtOb6YtOKArN9RkT0OOqQk17OzxvGqHUEXQ4eGmNgc8BLsGJn rsa-key-20230402"
        #fetchSSH "oatmealine@void-defragmented"
        #fetchSSH "oatmealine@beppy-phone"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAIphRdy+g7zfj+KxfONoD24lzk+/mGhQ0EnOe8QGf8 oatmealine@disroot.org" # gh actions
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTnK3uVMLp1RlWjynWRx1R/0CX0RkTiFGRtKqwYkNsB emmie"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMbifXjZuftTzyhVQwVZ0KuC2B2i7lUXDl5R9AyCosj ceri"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9BFJWinbzlv75QFkrlREI+C5+QOlncc9u+2uGKYfFx redbirdrabbit@gmail.com"
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

      pds = {
        enable = true;
        domain = "at.yugoslavia.best";
        package = pkgs.unstable.bluesky-pds;
      };

      ozone = {
        enable = true;
        domain = "ozone.yugoslavia.best";
        serviceHandle = "moderation.at.yugoslavia.best";
        serviceDID = "did:plc:kgpqgx33bhqf4sn7lb7thnzw";
        adminDIDs = lib.concatStringsSep "," [
          "did:plc:7eansezz3nlumwc7gfuiaksv" # jade
          "did:plc:2oqojyy6wcdnrktx4gjcodzs" # mayf
        ];
      };

      frp = {
        enable = true;
        port = 7000;

        freePorts.from = 48000;
        freePorts.to = 54000;

        # more permanent ports or ports requiring reverse proxying should go here
        freePorts.add = [
          # radio.oat.zone
          24454
        ];
      };
    };
  };

  programs.fish.enable = true;

  security.doas = {
    extraRules = [
      { users = [ "oatmealine" ]; noPass = true; persist = false; keepEnv = true; }
      # { users = [ "remote" ]; noPass = true; persist = false; keepEnv = true; }
    ];
  };

  time.timeZone = "Europe/Warsaw";

  networking = {
    firewall.allowPing = true;

    # pls don't add to these w/o documentation; use the free port range (48k-54k) for one-off uses
    #firewall.allowedTCPPorts = [];
  };
}
