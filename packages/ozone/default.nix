# heavily adapted from https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/bl/bluesky-pds/package.nix

{
  stdenv,
  makeBinaryWrapper,
  srcOnly,
  yarn-berry_4,
  fetchFromGitHub,
  nodejs,
  lib,
}:

let
  yarn-berry = yarn-berry_4;
in stdenv.mkDerivation rec {
  pname = "ozone";
  version = "0.1.104";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "ozone";
    tag = "v${version}";
    hash = "sha256-ibAgi6OLuEf1prCWc+Pe/NTiWXxYd1Zjtne1QLhRs5A=";
  };

  sourceRoot = "${src.name}/service";

  passthru.ui = stdenv.mkDerivation rec {
    pname = "ozone-ui";
    inherit src version;

    nativeBuildInputs = [
      yarn-berry.yarnBerryConfigHook
      makeBinaryWrapper
      nodejs
    ];

    missingHashes = ./missing-hashes.json;
    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit src missingHashes;
      hash = "sha256-F0gu6hdqXCx7Fok8ngRm0aLKRXMSoEgZNLmihLw6uvw=";
    };

    CYPRESS_INSTALL_BINARY = 0;

    buildPhase = ''
      runHook preBuild

      ${nodejs}/bin/npm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv .next $out

      runHook postInstall
    '';
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    makeBinaryWrapper
    nodejs
  ];

  missingHashes = ./missing-hashes-service.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit missingHashes;
    yarnLock = "${src}/service/yarn.lock";
    hash = "";
  };

  buildPhase = ''
    runHook preBuild

    makeWrapper "${lib.getExe nodejs}" "$out/bin/ozone" \
      --add-flags "$out/lib/ozone/index.js" \
      --chdir "$out/lib/ozone/" \
      --set-default NODE_ENV production

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/ozone}
    mv node_modules $out/lib/ozone
    mv index.js $out/lib/ozone

    cp -R ${passthru.ui}/ $out/lib/ozone/.next

    runHook postInstall
  '';

  meta = {
    description = "web interface for labeling content in atproto / Bluesky";
    homepage = "https://github.com/bluesky-social/ozone";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    mainProgram = "ozone";
  };
}
