{ pkgs, enable ? false, server-port, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
    gamemode = 0;
    motd = "Bingo Lockout, 1.21.10 Fabric";
    white-list = true;
    max-players = 16;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
  };

  #package = pkgs.fabricServers."fabric-1_20_1".override { loaderVersion = "0.15.6"; };
  #package = pkgs.fabricServers."fabric-1_21_4".override { jre_headless = pkgs.unstable.temurin-bin; };
  package = pkgs.fabricServers."fabric-1_21_10".override { jre_headless = pkgs.unstable.temurin-bin; };

  jvmOpts = "-Xmx6G";

  environment = {
    LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}";
  };
}
