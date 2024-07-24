{ pkgs, enable ? false, server-port, whitelist, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  inherit whitelist;
  serverProperties = {
    inherit server-port;
    gamemode = 0;
    motd = "Bingo Lockout, 1.21 Fabric";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
  };

  #package = pkgs.fabricServers."fabric-1_20_1".override { loaderVersion = "0.15.6"; };
  package = pkgs.fabricServers."fabric-1_21".override { jre_headless = pkgs.unstable.temurin-bin; };

  jvmOpts = "-Xmx6G";
}
