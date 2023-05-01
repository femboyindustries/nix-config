{ pkgs, lib, enable ? false, server-port, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
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

  symlinks = { "unsup.ini" = unsupINI; };
  # this is UGLY as FUCK; but unfortunately https://github.com/Infinidoge/nix-minecraft/issues/15
  package = pkgs.jdk17;
  jvmOpts = "-Xmx6G -javaagent:${unsup} "
    + lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/wafflecraft/libraries/net/minecraftforge/forge/1.18.2-40.2.1/unix_args.txt");
}
