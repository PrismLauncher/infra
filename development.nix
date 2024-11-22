{ flake-utils, nixpkgs, ... }:
flake-utils.lib.eachDefaultSystem (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [ just ];
    };
    formatter = pkgs.nixfmt-rfc-style;
  }
)
