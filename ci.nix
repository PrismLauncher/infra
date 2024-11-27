{
  self,
  nixpkgs,
  flake-utils,
  ...
}:

let
  inherit (nixpkgs) lib;
in

flake-utils.lib.eachDefaultSystem (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};

    mkCheck =
      name: deps: script:
      pkgs.runCommand "check-${name}" { nativeBuildInputs = deps; } ''
          ${script}
        touch $out
      '';
  in
  {
    apps = {
      generate-actions-matrix = {
        type = "app";
        program = lib.getExe (
          pkgs.writeShellApplication {
            name = "generate-actions-matrix";

            runtimeInputs = [
              pkgs.jq
              pkgs.nix-eval-jobs
            ];

            text = ''
              filter='
              {
                include: [
                  .[] | {
                    attr,
                    drvPath,
                    os: (
                      if .system == "x86_64-linux" then
                        "ubuntu-latest"
                      elif .system == "x86_64-darwin" then
                        "macos-13"
                      elif .system == "aarch64-darwin" then
                        "macos-latest"
                      else
                        null
                      end
                    )
                  }
                ]
              }
              '

              gcroot_dir="$(mktemp -d)"
              trap 'rm -rf "$gcroot_dir"' EXIT

              eval_jobs_args=(
                --flake '${self.outPath}#hydraJobs'
                --gc-roots-dir "$gcroot_dir"
                --option allow-import-from-derivation false
                --show-trace
              )

              jq_args=(
                --compact-output
                --slurp
                "$filter"
              )

              nix-eval-jobs "''${eval_jobs_args[@]}" | jq "''${jq_args[@]}"
            '';
          }
        );
      };
    };

    checks = {
      deadnix = mkCheck "deadnix" [ pkgs.deadnix ] "deadnix --fail ${self}";
      statix = mkCheck "statix" [ pkgs.statix ] "statix check ${self}";
    };
  }
)
// {
  hydraJobs =
    let
      ciSystem = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${ciSystem};

      nixosConfigurations = lib.mapAttrs (lib.const (
        configuration: configuration.config.system.build.toplevel
      )) self.nixosConfigurations;
    in
    {
      checks = lib.recurseIntoAttrs self.checks.${ciSystem};
      devShells = lib.recurseIntoAttrs self.devShells.${ciSystem};

      nixosConfigurations = lib.recurseIntoAttrs {
        # TODO: Inherit nixosConfigurations from above when we can actually
        # build ARM configurations in GHA
        andesite = builtins.deepSeq nixosConfigurations.andesite.drvPath pkgs.emptyFile;
      };
    };
}
