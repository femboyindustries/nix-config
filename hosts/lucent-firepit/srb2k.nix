{ config, lib, pkgs, ... }:

with lib;
let
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
  config = {
    modules.services.srb2k = with lib; with builtins; let
      addonDir = "/var/lib/srb2k/firepit/";
      fileNames = attrNames (readDir (/. + addonDir));
      addonFileNames = filter (n: hasSuffix ".lua" n || hasSuffix ".kart" n || hasSuffix ".pk3" n || hasSuffix ".wad" n) fileNames;
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
  };
}
