{ inputs, ... }:
# Most recent update to fork-upstream tried to remove this file but I think it's still in use 4/11/25
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { config, self', pkgs, lib, ... }: {
    # Add your auto-formatters here.
    # cf. https://nixos.asia/en/treefmt
    treefmt.config = {
      projectRootFile = "flake.nix";
      programs = {
        nixpkgs-fmt.enable = true;
        rustfmt.enable = true;
      };
    };
  };
}
