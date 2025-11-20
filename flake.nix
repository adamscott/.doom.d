{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs } @ inputs:
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
          _localEl = pkgs.writeTextFile {
            name = "+local.el";
            text = localEl;
          };
          fs = pkgs.lib.fileset;
        in
        pkgs.stdenvNoCC.mkDerivation {
          name = "DOOM Emacs config";
          src = fs.toSource {
            root = ./.;
            fileset = ./.;
          };
          installPhase = ''
            mkdir -p $out
            install init.el -T $out/init.el
            install config.el -T $out/config.el
            install packages.el -T $out/packages.el
            install custom.el -T $out/custom.el
            install ${_localEl} -T $out/+local.el
          '';
        };
      packages = forAllSystems(system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
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
