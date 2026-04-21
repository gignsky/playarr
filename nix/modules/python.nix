{ inputs, ... }:
{
  perSystem =
    {
      self',
      nixpkgs,
      ...
    }:
    {
      packages = {
        hello = inputs.dream2nix.lib.evalModules {
          packageSets.nixpkgs = nixpkgs.legacyPackages;
          modules = [
            ./hello.nix
            {
              paths = {
                projectRoot = ./.;
                projectRootFile = "flake.nix";
                paths.package = ./.;
              };
            }
          ];
        };
        # default = self'.packages.${system}.hello;
        default = self'.packages.hello;
      };
    };
}
