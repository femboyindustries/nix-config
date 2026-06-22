{ lib
, stdenv
, fetchFromGitHub, fetchYarnDeps
, fixup-yarn-lock, yarn, nodejs
, jpegoptim, oxipng, nodePackages
}: stdenv.mkDerivation (finalAttrs: {
  pname = "mangane";
  version = "1.13.3";

  meta = {
    description = "Alternative fontend for Akkoma";
    homepage = "https://github.com/BDX-town/Mangane";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ aether ];
  };

  src = fetchFromGitHub {
    owner = "BDX-town";
    repo = "Mangane";
    rev = "${finalAttrs.version}";
    hash = "sha256-gjkqN6fILmdQUkt0p513Rx4VuAs8xlEqK7D9SCmvDr4=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-B+MLfMKlbOUgwFg8vlwF8OrXHykDk1nEo47hWbr29A0=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    yarn
    nodejs
    jpegoptim
    oxipng
    nodePackages.svgo
  ];

  postPatch = ''
    # Build scripts assume to be used within a Git repository checkout
    sed -Ei '/^let commitHash =/,/;$/clet commitHash = "${builtins.substring 0 7 finalAttrs.src.rev}";' \
      webpack/production.js

    sed -Ei 's/npx webpack/npx webpack --offline/' \
      package.json
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$(mktemp -d)"

    yarn config --offline set yarn-offline-mirror ${lib.escapeShellArg finalAttrs.offlineCache}
    fixup-yarn-lock yarn.lock

    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export NODE_ENV="production"
    export NODE_OPTIONS="--openssl-legacy-provider"
    ${lib.getExe nodePackages.webpack-cli}

    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall

    # (Losslessly) optimise compression of image artifacts
    find static -type f -name '*.jpg' -execdir ${jpegoptim}/bin/jpegoptim -w$NIX_BUILD_CORES {} \;
    find static -type f -name '*.png' -execdir ${oxipng}/bin/oxipng -o max -t $NIX_BUILD_CORES {} \;
    find static -type f -name '*.svg' -execdir ${nodePackages.svgo}/bin/svgo {} \;

    cp -R -v static $out

    runHook postInstall
  '';
})
