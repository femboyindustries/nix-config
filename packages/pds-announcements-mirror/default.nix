{ buildNpmPackage }:

buildNpmPackage {
  pname = "pds-announcements-mirror";
  version = "0.0.0";

  src = ./.;

  doCheck = false;
  dontNpmBuild = true;

  npmDepsHash = "sha256-xc8S2Hxi/ZiRG8NcvCpzqNbbckKyhw+TNmnr1FI5/7Q=";

  meta.mainProgram = "pds-announcements-mirror";
}
