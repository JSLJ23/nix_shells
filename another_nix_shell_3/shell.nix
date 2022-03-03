{pkgs ? import <nixpkgs>{
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
}
}:

with pkgs;

let
    autodockgpu = import ./autodockgpu.nix {
        stdenv = pkgs.stdenv;
        lib = pkgs.lib;
        fetchFromGitHub = pkgs.fetchFromGitHub;
        cudatoolkit = pkgs.cudatoolkit_11_5;

    };

in
pkgs.mkShell {
  buildInputs = [
    autodockgpu
  ];

  shellHook = ''
    echo "You are now using a NIX environment"
    du -hc --max-depth=0 /nix/store # Show current size of nix store
    export CUDA_PATH=${pkgs.cudatoolkit_11_5}
    export CUDA_HOME=${pkgs.cudatoolkit_11_5}
    export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:${pkgs.cudatoolkit_11_5}/lib
  '';
}