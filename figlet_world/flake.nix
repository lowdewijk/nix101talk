{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    packages.x86_64-linux = {
      default = pkgs.stdenv.mkDerivation {
        name = "hello_world";
        system = "x86_64-linux";
        src = ./.;
        buildInputs = [pkgs.figlet];
        installPhase = ''
          mkdir -p $out/bin
          echo -e "#!/bin/sh\n${pkgs.figlet}/bin/figlet hello world" > $out/bin/hello_world
          chmod +x $out/bin/hello_world
        '';
      };

      dockerImage = pkgs.dockerTools.buildImage {
        name = "hello_world_docker";
        tag = "latest";
        copyToRoot = pkgs.buildEnv {
          name = "docker_layer";
          paths = [self.packages.x86_64-linux.default];
        };
        config = {
          Cmd = ["hello_world"];
        };
      };
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [self.packages.x86_64-linux.default];
    };
  };
}
