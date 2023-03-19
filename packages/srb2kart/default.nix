{ lib
, stdenv
, fetchurl
, fetchFromGitLab
, writeTextFile
, substituteAll
, cmake
, curl
, nasm
, unzip
, game-music-emu
, libpng
, SDL2
, SDL2_mixer
, zlib
}:

let

releaseTag = "v1.6";

assets = fetchurl {
  url = "https://github.com/STJr/Kart-Public/releases/download/${releaseTag}/AssetsLinuxOnly.zip";
  sha256 = "sha256-A4HkxnDGQICucsJyHXYc5GCRbMP0M4NjreohhFOQarA=";
};

in stdenv.mkDerivation rec {
  pname = "srb2kart";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "KartKrew";
    repo = "Kart-Public";
    domain = "git.do.srb2.org";
    rev = "024a140e8d8a1f86ccf16ef3dd93e3bccbe3bd73";
    sha256 = "sha256-5sIHdeenWZjczyYM2q+F8Y1SyLqL+y77yxYDUM3dVA0=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    unzip
  ];

  buildInputs = [
    curl
    game-music-emu
    libpng
    SDL2
    SDL2_mixer
    zlib
  ];

  cmakeFlags = [
    #"-DSRB2_ASSET_DIRECTORY=/build/source/assets"
    "-DGME_INCLUDE_DIR=${game-music-emu}/include"
    "-DSDL2_MIXER_INCLUDE_DIR=${lib.getDev SDL2_mixer}/include/SDL2"
    "-DSDL2_INCLUDE_DIR=${lib.getDev SDL2}/include/SDL2"
  ];

  patches = [
    #./disablemd5checks.patch
  ];

/*
  postPatch = ''
    substituteInPlace src/sdl/i_system.c \
        --replace '@wadlocation@' $out
  '';
*/

  preConfigure = ''
    mkdir -p assets/installer
    pushd assets/installer
    unzip ${assets}
    popd
    ls
    ls assets
    ls assets/installer
  '';


  postInstall = ''
    mkdir -p $out/bin $out/share/games/SRB2Kart
    mv $out/srb2kart* $out/bin/
    mv $out/*.kart $out/share/games/SRB2Kart
  '';

  meta = with lib; {
    description = "SRB2Kart is a classic styled kart racer";
    homepage = "https://mb.srb2.org/threads/srb2kart.25868/";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
  };
}
