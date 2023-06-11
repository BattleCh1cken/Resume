{
  description = "Resume";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex-env = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-medium fontawesome5 paracol tikz-3dplot smartdiagram xstring titlesec raleway ly1 sectsty tcolorbox environ lipsum;
        };
      in
      {
        devShells.default = pkgs.mkShell rec {
          packages = [
            tex-env
          ];
          name = "LaTeX";
        };
        packages.default = pkgs.stdenv.mkDerivation {
          name = "resume";
          src = self;

          buildInputs = [
            tex-env
          ];

          buildPhase = "latexmk -pdf";
          installPhase = "mkdir -p $out/; mv *.pdf $out/";
        };
      });
}
