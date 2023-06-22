{ stdenv, lib, fetchurl, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "GMusicBot";
  version = "2023-05-19";

  src = fetchurl {
    url = "https://oat.zone/f/GMusicBot-2023-05-19.jar?v=3";
    sha256 = "sha256-5c36did0kkaeu4Yi9vGIhlqRoeUBBRWKdihbaW9lwk4=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/lib
    cp $src $out/lib/GMusicBot

    makeWrapper ${jre_headless}/bin/java $out/bin/GMusicBot \
      --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/lib/GMusicBot"
  '';

  meta = with lib; {
    description = "Discord music bot that's easy to set up and run yourself";
    homepage = "https://git.oat.zone/oat/GMusicBot";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    inherit (jre_headless.meta) platforms;
  };
}
