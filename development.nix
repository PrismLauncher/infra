{ agenix, flake-utils, nixpkgs, ... }:
flake-utils.lib.eachDefaultSystem (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.default = pkgs.mkShellNoCC {
      packages = [ pkgs.just pkgs.opentofu agenix.packages.${system}.default ];
    };
    formatter = pkgs.nixfmt-rfc-style;
  }
)
