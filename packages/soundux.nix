{ stdenv, lib, fetchurl
, cmake
, alsaLib
, glib
, gtk3
, xorg
, webkitgtk
, libxkbcommon
, pulseaudio
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "soundux";
  version = "0.2.6";

  src = fetchurl {
    url = "https://github.com/Soundux/Soundux/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "0cffff520b3d1e69ccbb10599ff1ff3c911d74eb01a4af8dc3d5132fa5535c63";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = with xorg; [
    alsaLib glib gtk3 webkitgtk libxkbcommon pulseaudio pipewire libX11
  ];

  meta = with lib; {
    description = "A universal soundboard that uses PulseAudio modules or PipeWire linking";
    homepage = "https://soundux.rocks/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
