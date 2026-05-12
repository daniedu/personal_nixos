{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "opencode-bin";
  version = "latest";

  # Replace this URL with the actual binary URL the bash script downloads
  # You can find the URL by running: curl -sL https://opencode.ai/install | grep "BIN_URL"
  src = pkgs.fetchurl {
    url = "https://opencode.ai/releases/latest/opencode-linux-x64"; 
    sha256 = "PASTE_SHA256_HERE"; # Run 'nix-prefetch-url <url>' to get this
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  
  # Dependencies the binary might need (standard for most CLI tools)
  buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/opencode
    chmod +x $out/bin/opencode
  '';
}