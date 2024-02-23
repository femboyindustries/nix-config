{ pkgs, enable ? false, server-port, whitelist, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  inherit whitelist;
  serverProperties = {
    inherit server-port;
    gamemode = 0;
    motd = "dark-firepit, 1.20.1 Fabric";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
  };

  symlinks = { "unsup.ini" = unsupINI; };

  package = pkgs.fabricServers."fabric-1_20_1".override { loaderVersion = "0.15.6"; };
  # package = pkgs.fabricServers."fabric-1_20_1";

  jvmOpts = "-Xmx6G -javaagent:${unsup}";

}
