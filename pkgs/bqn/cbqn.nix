{ lib, stdenv, fetchFromGitHub, bqn, bqnRuntimeSrc }:

let
  name = "cbqn";
  version = "2021-09-26";
in
stdenv.mkDerivation {
  inherit name version;
  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "084eaaecbd26133891c6f1f78491efdc093aff68";
    sha256 = "1pf3jzxcs7ad08c5ikz6a83svg4zzhl39a5d0bjy43gylniw55l2";
  };

  nativeBuildInputs = [ bqn ];

  buildPhase =
    let
      CC =
        if stdenv.cc.isClang then "clang"
        else if stdenv.cc.isGNU then "gcc"
        else abort "Unsupported compiler: ${stdenv.cc}";
    in
    ''
      patchShebangs --host ./genRuntime
      ./genRuntime ${bqnRuntimeSrc}
      make CC=${CC}
    '';
  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 BQN $out/bin
  '';

  meta = with lib;{
    description = "a BQN implementation in C";
    homepage = "https://github.com/dzaima/CBQN";
    license = licenses.gpl3Plus;
    maintainers = "VojtechStep";
    platforms = platforms.unix;
  };
}
