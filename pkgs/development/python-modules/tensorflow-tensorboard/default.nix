{ lib, fetchPypi, buildPythonPackage, isPy3k
, numpy
, wheel
, werkzeug
, protobuf
, grpcio
, markdown
, futures
, absl-py
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "2.1.0";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "e6e64ec1e1500cc963b300895258f9605032c3a18bb40f95f2b3b12be16ff2f2";
  } else {
    python = "py2";
    sha256 = "1c80eb17c9d4f2609ed11b9446f8168973f5bb7789a97e56e766a89e062a00b9";
  }));

  propagatedBuildInputs = [
    numpy
    werkzeug
    protobuf
    markdown
    grpcio
    absl-py
    # not declared in install_requires, but used at runtime
    # https://github.com/NixOS/nixpkgs/issues/73840
    wheel
  ] ++ lib.optional (!isPy3k) futures;

  # in the absence of a real test suite, run cli and imports
  checkPhase = ''
    $out/bin/tensorboard --help > /dev/null
  '';

  pythonImportsCheck = [
    "tensorboard"
    "tensorboard.backend"
    "tensorboard.compat"
    "tensorboard.data"
    "tensorboard.plugins"
    "tensorboard.summary"
    "tensorboard.util"
  ];

  meta = with lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
