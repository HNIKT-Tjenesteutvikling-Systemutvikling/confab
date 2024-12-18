{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShell = let
        generateEditorConfig = pkgs.writeShellScriptBin "generateEditorConfig" ''
          if [ ! -f .editorconfig ]; then
            echo "root = true" > .editorconfig
            echo "" >> .editorconfig
            echo "[*]" >> .editorconfig
            echo "end_of_line = lf" >> .editorconfig
            echo "insert_final_newline = true" >> .editorconfig
            echo "indent_style = space" >> .editorconfig
            echo "tab_width = 4" >> .editorconfig
            echo "charset = utf-8" >> .editorconfig
            echo "" >> .editorconfig
            echo "[*.{yaml,yml,html,js,json}]" >> .editorconfig
            echo "indent_style = space" >> .editorconfig
            echo "indent_size = 2" >> .editorconfig
            echo "" >> .editorconfig
            echo "[*.{md,nix}]" >> .editorconfig
            echo "indent_style = space" >> .editorconfig
            echo "indent_size = 2" >> .editorconfig
          fi
        '';
      in
        pkgs.mkShell {
          name = "bloggen-2.0-dev";
          buildInputs = with pkgs; [
            python311
            nodePackages.pyright
            python311Packages.numpy
            python311Packages.black
            python311Packages.pygithub
          ];
          shellHook = ''
            ${generateEditorConfig}/bin/generateEditorConfig
          '';
        };
    });
}
