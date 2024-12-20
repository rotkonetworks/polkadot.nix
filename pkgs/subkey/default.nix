{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  protobuf,
  rocksdb,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "subkey";
  version = "stable2409-2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-${version}";
    hash = "sha256-M3Y7ourwOdDf2B42Q/eb8BCUtbOqy0sei3egb4ybrDc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ];

  buildAndTestSubdir = "substrate/bin/utils/subkey";

  doCheck = false;

  OPENSSL_NO_VENDOR = 1;
  PROTOC = "${lib.makeBinPath [ protobuf ]}/protoc";
  ROCKSDB_LIB_DIR = lib.makeLibraryPath [ rocksdb ];

  meta = with lib; {
    description = "Utility for generating and using Substrate keys";
    homepage = "https://github.com/paritytech/polkadot-sdk/tree/master/substrate/bin/utils/subkey";
    license = licenses.gpl3ClasspathPlus;
    maintainers = with maintainers; [ andresilva ];
    platforms = platforms.unix;
  };
}
