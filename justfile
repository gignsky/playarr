default:
	@just --list

# Run pre-commit hooks on all files, including autoformatting
pre-commit-all:
	pre-commit run --all-files

# Run 'cargo run' on the project
run *ARGS:
	just dont-fuck-my-build
	cargo run {{ARGS}}

# Run 'bacon' to run the project (auto-recompiles)
watch *ARGS:
	bacon --job run -- -- {{ ARGS }}

om *ARGS:
	nix run github:juspay/omnix -- {{ ARGS }}

show:
	just dont-fuck-my-build
	just om show .

health:
	just dont-fuck-my-build
	just om health .

clean:
	rm -rfv result
	cargo clean
	quick-results

dont-fuck-my-build:
	git ls-files --others --exclude-standard -- '*.nix' | xargs -r git add -v | lolcat
	echo "No chance your build is fucked! 👍" | lolcat

update:
	just dont-fuck-my-build
	cargo-update
	just update-flake

update-no-commit:
	just dont-fuck-my-build
	cargo-update --no-commit
	just update-flake-no-commit

update-flake:
	nix flake update --commit-lock-file

update-flake-no-commit:
	nix flake update

build *ARGS:
	just dont-fuck-my-build
	nix build {{ ARGS }}
	quick-results

top:
	just build .#topology.$system.config.output

check *ARGS:
	just dont-fuck-my-build
	nix flake check --impure --no-build {{ ARGS }}
	nix-shell -p lolcat --run 'echo "[CHECK] Finished." | lolcat'

generate:
	cargo generate ratatui/templates

# Auto-format the source tree
fmt:
	treefmt
