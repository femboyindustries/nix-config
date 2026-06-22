{ pkgs, lib, enable ? false, server-port, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
    gamemode = "survival";
    motd = "Forge 1.20.1";
    max-players = 16;
    allow-flight = true;
    enable-command-block = false;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
    white-list = true;
    view-distance = 16;
  };
  
  symlinks = { "unsup.ini" = unsupINI; };

  # this is UGLY as FUCK; but unfortunately https://github.com/Infinidoge/nix-minecraft/issues/15
  package = pkgs.jdk17;
  jvmOpts = "-Xmx8G -javaagent:${unsup} "
    + lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/smr/libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt");
}
