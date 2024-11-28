{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "cowsay_world";
  system = "x86_64-linux";
  src = ./.;
  buildInputs = [pkgs.cowsay];
  installPhase = ''
    mkdir -p $out/bin
    echo -e "#!/bin/sh\n ${pkgs.cowsay}/bin/cowsay -r hello world" > $out/bin/cowsay_world
    chmod +x $out/bin/cowsay_world
  '';
}
