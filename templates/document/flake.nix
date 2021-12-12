{
  description = "Foo Bar Document";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "foo-bar";
        pkgs = import nixpkgs { inherit system; };
      in rec {
        # nix build
        packages.${name} = pkgs.stdenv.mkDerivation {
          inherit name;
          src = ./.;
          buildInputs = with pkgs; [ pandoc texlive.combined.scheme-small plantuml pandoc-plantuml-filter ];
          buildPhase = ''
            shopt -s globstar

            # Convert diagrams to markdown with code blocks
            for diagram in src/**/*.uml; do
              markdown="''${diagram/.uml/.md}"
              echo '```plantuml' > "$markdown"
              cat $diagram >> "$markdown"
              echo '```' >> "$markdown"
            done

            # Build markdowns into pdf
            pandoc src/**/*.md -o document.pdf \
              --filter pandoc-plantuml
          '';
          installPhase = ''
            mkdir -p $out
            install -Dm644 *.pdf $out
          '';
        };
        defaultPackage = packages.${name};

        # nix develop
        devShell =
          pkgs.mkShell {
            inputsFrom = [ defaultPackage ];
            buildInputs = with pkgs; [ inotify-tools ];
          };
      });
}
