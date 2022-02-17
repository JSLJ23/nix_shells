{pkgs ? import <nixpkgs>{
    config = {
        allowUnfree = true;
        cudaSupport = true;
    };
}
}:

with pkgs;

pkgs.mkShell {
  buildInputs = [
    pkgs.singularity
  ];

  shellHook = ''
    echo "You are now using a NIX environment"
    du -hc --max-depth=0 /nix/store # Show current size of nix store
  '';
}


