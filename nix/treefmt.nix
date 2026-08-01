{...}: {
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
            }∑