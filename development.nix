{
  agenix,
  flake-utils,
  nixpkgs,
  self,
  treefmt-nix,
  ...
}:
flake-utils.lib.eachDefaultSystem (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
  in
  {
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        pkgs.just
        pkgs.opentofu
        agenix.packages.${system}.default
      ];
    };

    checks.formatting = treefmtEval.config.build.check self;

    formatter = treefmtEval.config.build.wrapper;
  }
)
