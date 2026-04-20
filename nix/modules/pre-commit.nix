{ inputs, ... }:
{
  imports = [
    (inputs.git-hooks + /flake-module.nix)
  ];
  perSystem = _: {
    pre-commit.settings = {
      hooks = {
        # Nix formatting and linting (from .dotfiles)
        nixfmt.enable = true;
        statix.enable = true;
        deadnix = {
          enable = true;
          excludes = [ "nix/modules/template.nix" ]; # Exclude template files that might have intentional dead code
        };

        # Rust formatting and linting
        rustfmt.enable = true;
        clippy = {
          enable = false; # Disabled for now, as it can be too strict for some projects
          settings = {
            allFeatures = true;
            denyWarnings = true;
          };
        };

        # Shell script linting (from .dotfiles)
        shellcheck.enable = false;

        # Markdown and YAML linting (from .dotfiles)
        markdownlint.enable = false; # Disabled for now due to strict formatting on existing files
        yamllint.enable = false; # Disabled for now due to strict formatting on existing files

        # File cleanup (from .dotfiles)
        end-of-file-fixer.enable = true;

        # # Custom flake check hook (from .dotfiles)
        # nix-flake-check-main-develop = {
        #   enable = true;
        #   name = "nix flake check on develop/main";
        #   entry = "./scripts/pre-commit-flake-check.sh";
        #   language = "script";
        #   pass_filenames = false;
        #   stages = [ "pre-commit" "pre-merge-commit" ];
        # };
      };
    };
  };
}
