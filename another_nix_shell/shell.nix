# shell.nix
{ pkgs ? import <nixpkgs> {
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
} }:

with pkgs;

let
    my-python = pkgs.python39;
        python-with-my-packages = my-python.withPackages (p: with p; [
        pandas
        requests
        termcolor
        ViennaRNA
        # other python packages you want
    ]);
in
pkgs.mkShell {
    buildInputs = [
        python-with-my-packages
        # other dependencies
    ];
    shellHook = ''
        PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
        echo $PYTHONPATH
        export CUDA_PATH=${pkgs.cudatoolkit}
        du -hc --max-depth=0 /nix/store # Show current size of nix store
    '';
}
