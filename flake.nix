{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable } @ inputs:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      doomEmacsConfigFn = {
        pkgs,
        localEl ? ''

        '',
        ...
      }:
        let
        in
        pkgs.symlinkJoin {
          name = "DOOM Emacs config";
          paths = [
            (pkgs.writeTextFile {
              name = "init.el";
              text = builtins.readFile ./init.el;
            })
            (pkgs.writeTextFile {
              name = "config.el";
              text = builtins.readFile ./config.el;
            })
            (pkgs.writeTextFile {
              name = "packages.el";
              text = builtins.readFile ./packages.el;
            })
            (pkgs.writeTextFile {
              name = "custom.el";
              text = builtins.readFile ./custom.el;
            })
            (pkgs.writeTextFile {
              name = "+local.el";
              text = localEl;
            })
          ];
        };
      packages = forAllSystems(system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          unstable-pkgs = nixpkgs-unstable.legacyPackages.${system};
          selfPackages = self.outputs.packages.${system};
        in
        {
          doomEmacsConfig = (doomEmacsConfigFn {
            inherit pkgs;
            localEl = ''
            
            '';
          });
        }
      );
      devShells = forAllSystems(system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
           default = pkgs.callPackage ./shell.nix {
            inherit pkgs;
          };
        }
      );
    in
    {
      inherit packages;
      inherit devShells;

      lib = {
        doomEmacsConfig = doomEmacsConfigFn;
      };
    };
}
