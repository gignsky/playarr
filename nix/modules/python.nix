{ inputs, ... }:
{
  perSystem =
    {
      self',
      nixpkgs,
      ...
    }:
    let
      project = inputs.pyproject-nix.lib.project.loadRequirementsTxt { projectRoot = ../../.; };
      pkgs = nixpkgs.legacyPackages;
      python = pkgs.python3;
      pythonEnv =
        # Assert that versions from nixpkgs matches what's described in requirements.txt
        # In projects that are overly strict about pinning it might be best to remove this assertion entirely.
        assert project.validators.validateVersionConstraints { inherit python; } == { };
        (
          # Render requirements.txt into a Python withPackages environment
          pkgs.python3.withPackages (project.renderers.withPackages { inherit python; })
        );
    in
    {
      devShells.default = pkgs.mkShell { packages = [ pythonEnv ]; };
      # packages = {
      #   hello = inputs. {
      #   default = self'.packages.hello;
      # };
    };
}
