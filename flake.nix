
{
  description = "Darkmatter Nix Flake Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    prelude.url = "github:darkmatter/prelude";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.prelude.flakeModules.default
          ./prelude.nix
          inputs.treefmt-nix.flakeModule
        ];
        systems = [
          "aarch64-darwin"
          "x86_64-linux"
          "aarch64-linux"
        ];

        perSystem = { config, pkgs, ... }: {

            treefmt.config = {
              projectRootFile = "flake.nix";
              programs = {
                prettier.enable = true;
                rustfmt.enable = true;
                nixfmt.enable = true;
                taplo.enable = true;
              };
              # Generated output is committed as its generator emits it; see
              # .prettierignore for why formatting it breaks `db:codegen --verify`.
              settings.global.excludes = [
                "result/*"
              ];
            };

            devShells.default = pkgs.mkShell {
              name = "myapp-devshell";
              buildInputs = [];
              packages = with pkgs; [
                git
                jq
                sops
                age
                config.packages.prelude
              ];

              shellHook = ''
                motd
              '';
            };
          };
      }
    );

}
