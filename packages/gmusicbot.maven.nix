{ lib, pkgs }:

let
  shade_1_5 = map (obj: pkgs.javaPackages.fetchMaven {
    version = "1.5";
    artifactId = "maven-shade-plugin";
    groupId = "org.apache.maven.plugins";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "sha512-AoBtMzmqWMiOz5CSzl6ucYXK2iPtYbSlbsa2f8gCeP9ZtZfM+LkrEVzF9JcWsn+qbA9zC84O0fUyt7fJl8ZrBg=="; }
    { type = "pom"; sha512 = "sha512-YJTFhsAs3hV26L0+fAStwY6AHnPx6+cCo6yP/ZJTOUZvrlNTA1qxP/aBYjhPX3IvQ+UhagwdrSbA4uIS3w5sUw=="; }
  ];
in pkgs.javaPackages.mavenbuild rec {
  version = "2023-05-19";
  name = "gmusicbot-${version}";

  mavenDeps = [
    shade_1_5
  ];
  m2Path = "/jmusicbot/jmusicbot/${version}";
  
  src = pkgs.fetchFromGitea {
    domain = "git.oat.zone";
    owner = "oat";
    repo = "GMusicBot";
    rev = "master";
    sha256 = "sha256-+sH5LI7PUN25rR1DM529Ly0WPHB4/JIQAPxWi0IlsZ4=";
  };

  meta = with pkgs.lib; {
    description = "Discord music bot that's easy to set up and run yourself";
    homepage = "https://git.oat.zone/oat/GMusicBot";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    inherit (pkgs.jre_headless.meta) platforms;
  };
}
