{pkgs ? import <nixpkgs> {}, ...}:
derivation {
  name = "hello_world";
  system = "x86_64-linux";
  builder = "${pkgs.bash}/bin/bash";
  nativeBuildInputs = [pkgs.bash pkgs.coreutils];
  args = [
    "-c"
    ''
      ${pkgs.coreutils}/bin/mkdir -p $out/bin;
      echo -e "#!/bin/sh\necho hello world" > $out/bin/hello_world;
      ${pkgs.coreutils}/bin/chmod +x $out/bin/hello_world
    ''
  ];
}
