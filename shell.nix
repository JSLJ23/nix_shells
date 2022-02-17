# shell.nix
with import <nixpkgs>{};

let
    qvina_bin = stdenv.mkDerivation rec {
        name = "qvina-bin-${version}";
        version = "2.1";
        src = fetchurl {
            url = "https://github.com/QVina/qvina/archive/refs/heads/master.tar.gz";
            sha256 = "sha256:0smma7q7yq1d9jjzziq7lb5c9azxbcffs9i7fr4g7ax9wr27sz7w";
        };

        nativeBuildInputs = [ autoPatchelfHook ];

        buildInputs = [ boost159 ];

        sourceRoot = ".";

        installPhase = ''
            install -m755 -D ./qvina-master/bin/qvina${version} $out/bin/qvina${version}
        '';
    };

    my-python = pkgs.python39;
        python-with-my-packages = my-python.withPackages (p: with p; [
        pandas
        requests
        ViennaRNA
        # other python packages you want
    ]);

in
pkgs.mkShell {
    buildInputs = [
        python-with-my-packages
        qvina_bin
        # other dependencies
    ];
    shellHook = ''
        export NIXPKGS_ALLOW_UNFREE=1
        PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
        echo $PYTHONPATH
    '';
}