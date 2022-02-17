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
        cudatoolkit = pkgs.cudatoolkit_11;

    };

in
pkgs.mkShell {
  buildInputs = [
    autodockgpu
  ];

  shellHook = ''
    echo "You are now using a NIX environment"
    du -hc --max-depth=0 /nix/store # Show current size of nix store
  '';
}