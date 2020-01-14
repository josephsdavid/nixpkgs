{ stdenv, fetchPypi, buildPythonPackage
, numpy
, absl-py 
, mock
}:

buildPythonPackage rec {
  pname = "tensorflow-estimator";
  # This is effectively 1.15.0. Upstream tagged 1.15.0 by mistake before actually updating the version in setup.py, which is why this tag is called 1.15.1.
  version = "2.1.0";
  format = "wheel";

  src = fetchPypi {
    pname = "tensorflow_estimator";
    inherit version format;
    sha256 ="e5c5f648a636f18d1be4cf7ed46132b108a2f0f3fd9f1c850eba924263dc6972";
  };

  propagatedBuildInputs = [ mock numpy absl-py ];

  meta = with stdenv.lib; {
    description = "TensorFlow Estimator is a high-level API that encapsulates model training, evaluation, prediction, and exporting.";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp ];
  };
}

