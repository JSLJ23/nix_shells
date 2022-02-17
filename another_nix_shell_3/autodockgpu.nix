# import dependencies
{ lib
, stdenv
, fetchFromGitHub
, cudatoolkit
}:

# make derivation
stdenv.mkDerivation rec {
    pname = "AutoDock-GPU";
    version = "1.5.3";

    src = fetchFromGitHub {
        owner = "ccsb-scripps";
        repo = "AutoDock-GPU";
        rev = "7b7d5ed516f870611a93b14e14c6b64023eccb14";
        sha256 = "sha256-9Bc5OEbI8NPY+MF73Vvo42IBiWo7JJo0cQ3c2yArTks=";
    };

    buildInputs = [ cudatoolkit ];

    makeFlags = [ "DEVICE=CUDA NUMWI=128" ];

    installPhase = ''
        install -m755 -D ./bin/autodock_gpu_128wi $out/bin/autodock_gpu_128wi
    '';

    preConfigure = ''
        export CPU_INCLUDE_PATH=${cudatoolkit}/include
        export CPU_LIBRARY_PATH=${cudatoolkit}/lib
        export GPU_INCLUDE_PATH=${cudatoolkit}/include
        export GPU_LIBRARY_PATH=${cudatoolkit}/lib
    '';

    meta = with lib; {
        description = " AutoDock for GPUs and other accelerators ";
        homepage = "https://autodock.scripps.edu/";
        license = licenses.gpl3;
        maintainers = [ maintainers.iimog ];
        # at least SSE is *required*
        platforms = platforms.x86_64;
    };
}