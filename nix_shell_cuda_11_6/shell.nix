{pkgs ? import <nixpkgs>{
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
}
}:

with pkgs;

let
    cudatoolkit = import ./cuda.nix {
        callPackage = pkgs.callPackage;
        fetchurl = pkgs.fetchurl;
        gcc7 = pkgs.gcc7;
        gcc9 = pkgs.gcc9;
        gcc10 = pkgs.gcc10;
        lib = pkgs.lib;

    };

    autodockgpu = import ./autodockgpu.nix {
        stdenv = pkgs.stdenv;
        lib = pkgs.lib;
        fetchFromGitHub = pkgs.fetchFromGitHub;
        cudatoolkit = cudatoolkit.cudatoolkit_11_6;

    };

in
pkgs.mkShell {
  buildInputs = [
    autodockgpu

    python3Packages.pytorch-bin
  ];

  shellHook = ''
    echo "You are now using a NIX environment"
    du -hc --max-depth=0 /nix/store # Show current size of nix store
    export CUDA_PATH=${cudatoolkit.cudatoolkit_11_6}
    export CUDA_HOME=${cudatoolkit.cudatoolkit_11_6}
    export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:${cudatoolkit.cudatoolkit_11_6}/lib
  '';
}