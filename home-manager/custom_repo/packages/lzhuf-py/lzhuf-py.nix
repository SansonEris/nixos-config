{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "lzhuf";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "DerHirschi";
    repo = "lzhuf.py";
    rev = "511a0d9";
    sha256 = "sha256-iX+Jq+Cjoy1hnbbp81QRx0scMp0V47KJGPSGlwxTYAM=";
  };

  nativeBuildInputs = [ python3Packages.setuptools ];

  # postPatch: crea setup.py e prepara il modulo
  postPatch = ''
    mkdir -p lzhuf
    cp lzhuf.py lzhuf/__init__.py

    # setup.py corretto senza indentazioni errate
    cat > setup.py <<EOF
from setuptools import setup
setup(
    name='lzhuf',
    version='1.0',
    packages=['lzhuf'],
)
EOF
  '';

  # opzionale: installPhase standard
  installPhase = ''
    python setup.py install --prefix=$out
  '';

  meta = with lib; {
    description = "Python implementation of the LZHUF compression algorithm";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
