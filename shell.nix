{ pkgs ? import <nixpkgs> { config.android_sdk.accept_license = true; } }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "36" ];
    buildToolsVersions = [ "36.0.0" ];
    includeNDK = false;
    includeEmulator = false;
    includeSystemImages = false;
  };
  androidSdk = androidComposition.androidsdk;
in
(pkgs.buildFHSEnv {
  name = "android-env";
  targetPkgs = p: [
    androidSdk
    p.jdk17
    p.gradle
    p.zlib
  ];
  profile = ''
    export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
    export JAVA_HOME="${pkgs.jdk17}"
  '';
  runScript = "bash";
}).env
