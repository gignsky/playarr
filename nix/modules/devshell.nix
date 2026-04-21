_: {
  perSystem =
    {
      config,
      self',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "playarr-shell";
        inputsFrom = [
          self'.devShells.rust
          config.pre-commit.devShell # See ./nix/modules/pre-commit.nix
        ];
        packages = with pkgs; [
          # nix stuff
          nixd
          nixfmt

          # rust stuff
          rustfmt
          clippy
          bacon
          # config.process-compose.cargo-doc-live.outputs.package

          # utilities
          gitflow

          # gigdot programs
          inputs.gigdot.packages.${system}.quick-results
          inputs.gigdot.packages.${system}.upjust
          inputs.gigdot.packages.${system}.upspell
          inputs.gigdot.packages.${system}.upflake
          inputs.gigdot.packages.${system}.cargo-update
        ];
        shellHook = ''
          echo "welcome to the rust development environment for the playarr package" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat 2> /dev/null;
        '';
      };
    };
}
