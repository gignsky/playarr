{ ... }:
{
  perSystem =
    {
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "playarr-shell";
        inputsFrom = [
          self'.devShells.rust
          config.treefmt.build.devShell
          config.pre-commit.devShell # See ./nix/modules/pre-commit.nix
        ];
        packages = with pkgs; [
          just
          nixd # Nix language server
          bacon
          config.process-compose.cargo-doc-live.outputs.package
          nil
          lolcat
          wslu
          cargo-generate
          openssl

          # # dotfiles programs
          # inputs.dotfiles.packages.${system}.quick-results
          # inputs.dotfiles.packages.${system}.upjust
          # inputs.dotfiles.packages.${system}.cargo-update
        ];
        shellHook = ''
          echo "welcome to the rust development environment" | ${pkgs.cowsay}/bin/cowsay
        '';
      };
    };
}
