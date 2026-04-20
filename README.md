A template Rust project with fully functional and no-frills Nix support, as well as builtin VSCode configuration to get IDE experience without any manual setup (just [install direnv](https://nixos.asia/en/direnv), open in VSCode and accept the suggestions). It uses [crane](https://crane.dev/), via [rust-flake](https://github.com/juspay/rust-flake).

> [!NOTE]
> If you are looking for the original template based on [this blog post](https://srid.ca/rust-nix)'s use of `crate2nix`, browse from [this tag](https://github.com/srid/playarr/tree/crate2nix). The evolution of this template can be gleaned from [releases](https://github.com/srid/playarr/releases).

## Usage

You can use [omnix](https://omnix.page/om/init.html)[^omnix] to initialize this template:
```
nix --accept-flake-config run github:juspay/omnix -- init github:gignsky/playarr -o ~/my-rust-project
```

[^omnix]: If initializing manually, make sure to:
    - Change `name` in Cargo.toml.
    - Run `cargo generate-lockfile` in the nix shelld

## Adapting this template

- There are two CI workflows, and one of them uses Nix which is slower (unless you configure a cache) than the other one based on rustup. Pick one or the other depending on your trade-offs.

## Development (Flakes)

This repo uses [Flakes](https://nixos.asia/en/flakes) from the get-go.

```bash
# Dev shell
nix develop

# or run via cargo
nix develop -c cargo run

# build
nix build
```

We also provide a [`justfile`](https://just.systems/) for Makefile'esque commands to be run inside of the devShell.

## Tips

- Run `nix flake update` to update all flake inputs.
- Run `nix --accept-flake-config run github:juspay/omnix ci` to build _all_ outputs.
- Run `just check` to run flake checks (automatically skips template.nix which won't be in downstream repos).
- Run `just check-template` to run flake checks including template.nix (useful for debugging template issues).
- [pre-commit] hooks will automatically be setup in Nix shell. You can also run `pre-commit run -a` manually to run the hooks (e.g.: to autoformat the project tree using `rustfmt`, `nixpkgs-fmt`, etc.).

## Discussion

- [Zulip](https://nixos.zulipchat.com/#narrow/stream/413950-nix)

## See Also

- [nixos.wiki: Packaging Rust projects with nix](https://nixos.wiki/wiki/Rust#Packaging_Rust_projects_with_nix)


------------------------------ PRE-GEN README STARTS HERE FOR NON-TEMPLATE ---------------------------------------------[
   
![CI Nix](https://github.com/gignsky/playarr/actions/workflows/ci-nix.yml/badge.svg)](https://github.com/gignsky/playarr/actions/workflows/ci-nix.yml)
[![Docs](https://github.com/gignsky/playarr/actions/workflows/docs.yml/badge.svg)](https://github.com/gignsky/playarr/actions/workflows/docs.yml)
[![Release](https://github.com/gignsky/playarr/actions/workflows/release.yml/badge.svg)](https://github.com/gignsky/playarr/actions/workflows/release.yml)
[![Update README with --help Output](https://github.com/gignsky/playarr/actions/workflows/help-to-readme.yml/badge.svg)](https://github.com/gignsky/playarr/actions/workflows/help-to-readme.yml)

A command line utility written entirely in rust that creates tarballs from folders in the current working directory and optionally remove the folders that created those tarballs

# Installation & Usage
### Run immediately without installing (using Nix)
`$ nix run github:gignsky/playarr -- {optional-arguments (i.e. --help)}`

## Installation
### With Nix Shell (temporary installation in current shell)
`$ nix shell github:gignsky/playarr`

### With NixOS (using flakes)
In your `flake.nix` file: 
1. add `inputs.playarr.url = "github:gignsky/playarr";` to your inputs
2. inside of your `environment.systemPackages` often defined under: `outputs.nixosConfigurations.{hostname}.nixpkgs.lib.nixosSystem.modules`
3. add either:
   1. `inputs.playarr.packages.${system}.playarr`
   2. `inputs.playarr.packages.${system}.default`

### Download the binary
1. Navigate to https://github.com/gignsky/playarr/releases
2. Download the latest (or desired) release for your operating system
   1. As of the time of this writing only x86_64 binaries are compiled for GNU/Linux and windows
3. if using Linux run `chmod +x ./{downloaded-binary}`
4. if using windows you can run the binary from the command prompt or powershell in order to pass arguments, if double-click running the .exe file the default process of the binary will run in the current folder of the binary without the remove flag
   1. FUTURE FUNCTIONALITY INTENDED: In the future it is intended that the program will produce a dialog box that allows the user to specify which option arguments to be used. 

### Compile the binary yourself
1. git clone this repository:
   1. `$ git clone https://github.com/gignsky/playarr.git`
2. cd into the directory:
   1. `$ cd playarr`
3. enter development environment:
   1. `$ nix develop`
4. build binary with justfile (uses nix build command) or build with cargo
   1. `$ just build`
      1. nix build command
      2. produces a binary in `./result/bin/playarr`
   2. `$ cargo build`
      1. cargo build command (debug)
      2. produces a debug binary in `./target/debug/playarr`
   3. `$ cargo build --release`
      1. cargo build command (release)
      2. produces a debug binary in `./target/release/playarr`
5. in order to use this compiled binary in any location one must add the binary to their $PATH (this is OS specific and not within the scope of this README)
   1. NOTE: This is not an issue if installed using nix, whether that be flakes and NixOS or nix shell

## Usage

### When downloading the binary or compiling yourself   
`$ ./{downloaded-binary} {optional-arguments (i.e. --help)}`

### When installed via Nix
`$ playarr {optional-arguments (i.e. --help)}`

## Optional Arguments (automatically generated by github action)
```
A simple Rust project using Nix

Usage: playarr [OPTIONS] [NAME]

Arguments:
  [NAME]  an optional name to greet

Options:
  -v             whether to be verbose
  -h, --help     Print help
  -V, --version  Print version
```

# Development (Flakes)

This repo uses [Flakes](https://nixos.asia/en/flakes) from the get-go.

```bash
# Dev shell
nix develop

# or run via cargo
nix develop -c cargo run

# build
just build
```

We also provide a [`justfile`](https://just.systems/) for Makefile'esque commands to be run inside of the devShell.
You can run `$ just` inside `$ nix develop` to see all available just outputs

## Testing

This template includes comprehensive testing infrastructure adapted from [.dotfiles](https://github.com/gignsky/dotfiles) configurations:

### Available Test Commands

```bash
# Run all tests (Rust + Nix)
just test

# Run only Rust tests
just test-rust

# Run template-specific tests (includes template.nix)
just test-template

# Run clippy linting
just clippy

# Check Rust formatting
just fmt-check

# Simulate CI locally
just ci

# Run pre-commit flake check
just pre-commit-check
```

### Manual Testing

```bash
# Test Rust functionality
cargo test --all-features
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt -- --check

# Test Nix build system
nix flake check --impure --no-build  # Skip template.nix
nix flake check                       # Include template.nix
nix build --no-link

# Test template functionality
nix --accept-flake-config run github:juspay/omnix -- ci --no-build
```

### CI/CD

The project includes multiple GitHub Actions workflows:

- **Cargo CI** (`check.yml`) - Runs Rust tests, formatting, and linting
- **Nix CI** (`ci-nix.yml`) - Runs Nix flake checks and omnix CI
- **Template Check** (`template-check.yml`) - Tests template-specific functionality

### Pre-commit Hooks

Pre-commit hooks are automatically configured and include:
- `rustfmt` - Rust code formatting
- `clippy` - Rust linting
- `nixpkgs-fmt` - Nix code formatting  
- `flake-check` - Custom Nix flake validation

## Tips

- Run `$ just update-flake` to update all flake inputs.
- Run `$ just update` to update all flake inputs and cargo dependencies
- Run `$ just check` to run flake checks (automatically skips template.nix which won't be in downstream repos).
- Run `$ just check-template` to run flake checks including template.nix (useful for debugging template issues).
- Run `nix --accept-flake-config run github:juspay/omnix ci` to build _all_ outputs.
- [pre-commit] hooks will automatically be setup in Nix shell. You can also run `pre-commit run -a` manually to run the hooks (e.g.: to autoformat the project tree using `rustfmt`, `nixpkgs-fmt`, etc.).
