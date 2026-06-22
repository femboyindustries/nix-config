{ pkgs, lib, enable ? false, server-port, unsup, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
    gamemode = "0";
    motd = "Rewind Upsilon, 1.4.7";
    max-players = 20;
    allow-flight = true;
    spawn-protection = 0;
    #white-list = true;
    white-list = false;
    view-distance = 10;
  };

  symlinks = {
    "unsup.ini" = pkgs.writeTextFile {
      name = "unsup.ini";
      text = ''
        version=1
        preset=minecraft
        
        source_format=packwiz
        source=https://rewindmc.com/packwiz/upsilon/pack.toml
        
        force_env=server
        
        [flavors]
        flavor=standard
        gregtech=gregtech_on
        dartcraft=dartcraft_on
      '';
    };
  };

  package = pkgs.jdk8;
  jvmOpts = "-javaagent:${unsup} -Dnil.alwaysUseAdHocLogger=true -Xmn128M -Xms4G -Xmx4G -javaagent:nilloader.jar -cp forge.jar:minecraft-server.jar net.minecraft.server.MinecraftServer";
    #+ lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/minehattan/libraries/net/minecraftforge/forge/1.19.2-43.3.0/unix_args.txt");
}
