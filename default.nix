with import <nixpkgs> {};

let
  ppackages = python35Packages;

  cryptominisat = stdenv.mkDerivation rec {
    name = "cryptominisat-${version}";
    version = "5.0.1";

    src = fetchurl {
      url = "https://github.com/msoos/cryptominisat/archive/${version}.tar.gz";
      sha256 = "0qz2llq8l5y6slgshwiq1f72cjrpbs1vvqg4907r3mfb1v4m77bq";
    };
    # vim is needed for `xxd`
    buildInputs = [ cmake vim boost ];
  };

in rec {
  python-cryptominisat = ppackages.buildPythonPackage rec {
    name = "python-cryptominisat-${version}";
    version = "0.1-501";

    src = ./.;
    buildInputs = [ python3 cryptominisat ppackages.cython ];
  };

  dev = stdenv.mkDerivation rec {
    name = "dev";
    buildInputs = [ python3 cryptominisat ppackages.cython ];
  };
}
