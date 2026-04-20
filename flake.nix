{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    systems.url = "github:nix-systems/default";
    rust-flake = {
      url = "github:juspay/rust-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dev tools
    # process-compose-flake.url = "github:Platonic-Systems/process-compose-flake/f6ce9481df9aec739e4e06b67492401a5bb4f0b1";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    # cargo-doc-live.url = "github:srid/cargo-doc-live/b09d5d258d2498829e03014931fc19aed499b86f";
    cargo-doc-live.url = "github:srid/cargo-doc-live";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      flake = false;
    };

    # # personal repos
    # gigdot = {
    #   url = "github:gignsky/dotfiles";
    #   flake = true;
    # };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      # See ./nix/modules/*.nix for the modules that are imported here.
      # Conditionally exclude template.nix during flake checks
      imports =
        with builtins;
        let
          allModules = attrNames (readDir ./nix/modules);
          # Skip template.nix if NIX_SKIP_TEMPLATE is set (useful for flake check)
          filteredModules =
            if (getEnv "NIX_SKIP_TEMPLATE" != "") then
              filter (fn: fn != "template.nix") allModules
            else
              allModules;
        in
        map (fn: ./nix/modules/${fn}) filteredModules;
    };
}
