{
  perSystem =
    { inputs', pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          pkgs.just
          pkgs.opentofu
          inputs'.agenix.packages.default
        ];
      };
    };
}
