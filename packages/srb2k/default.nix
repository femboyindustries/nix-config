{ lib
, stdenv
, SDL2
, SDL2_mixer
, libgme
, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "srb2k";
  version = "1.3";

  src = fetchFromGitLab {
    owner = "himie";
    repo = "kart-public";
    rev = "8cd205cd2807c6a2064935c8b873972c6570e715";
    sha256 = "0";
  };

  buldInputs = [
    SDL2
    SDL2_mixer
    libgme
    cmake
  ];

  cmakeFlags = [ "-march=native" ];
}
