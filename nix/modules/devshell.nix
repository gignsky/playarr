{ inputs, ... }:
{
  perSystem =
    {
      # config,
      self',
      pkgs,
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "playarr-shell";
        inputsFrom = [
          self'.devShells.rust
          # config.pre-commit.devShell # See ./nix/modules/pre-commit.nix
        ];
        # UV_PYTHON_DOWNLOADS = "never";
        # localBinInPath = true;
        packages = with pkgs; [
          # ==========================================
          # NIX DEVELOPMENT
          # ==========================================
          nixd
          nixfmt

          # ==========================================
          # RUST DEVELOPMENT
          # ==========================================
          rustfmt
          clippy
          bacon
          cargo-watch # Auto-rebuild on file changes
          cargo-expand # Expand macros (useful for async/tokio)
          cargo-flamegraph # Performance profiling
          cargo-udeps # Find unused dependencies
          # config.process-compose.cargo-doc-live.outputs.package

          # ==========================================
          # DATABASE TOOLS (SQLite)
          # ==========================================
          sqlite # SQLite CLI
          sqlitebrowser # GUI for SQLite (Qt-based)
          litecli # Modern SQLite CLI with syntax highlighting
          sqlx-cli # SQLx migrations and database management
          dbeaver-bin # Universal database GUI (supports SQLite, Postgres, etc.)

          # ==========================================
          # HTTP/API TESTING
          # ==========================================
          curl # Classic HTTP client
          httpie # Modern HTTP client (better than curl for APIs)
          xh # Rust-based httpie alternative (faster)
          curlie # curl with httpie-like syntax
          hurl # HTTP testing with plain text files
          bruno # Open-source Postman alternative (GUI)

          # # Advanced API testing
          # k6                # Load testing tool
          # hey               # HTTP benchmarking
          # jq                # JSON processor (essential!)
          # jless             # JSON viewer/explorer (interactive)
          # fx                # JSON viewer with JavaScript syntax
          # gron              # Make JSON greppable
          # yq-go             # YAML/JSON/XML processor

          # ==========================================
          # CONTAINER DEVELOPMENT
          # ==========================================
          # docker
          # docker-compose
          # podman            # Alternative to Docker
          # skopeo            # Container image manipulation
          # dive              # Explore Docker image layers
          # docker-compose-language-service  # docker-compose.yml LSP
          # hadolint          # Dockerfile linter

          # ==========================================
          # NETWORKING/DEBUGGING
          # ==========================================
          netcat # Network debugging
          nmap # Network scanner
          tcpdump # Packet analyzer
          wireshark # GUI packet analyzer
          mitmproxy # HTTP/HTTPS proxy for debugging
          # ngrok # Expose local server to internet (for webhook testing)

          # ==========================================
          # MONITORING/OBSERVABILITY
          # ==========================================
          tokei # Code statistics
          hyperfine # Benchmarking tool
          bottom # htop alternative (btm)
          bandwhich # Network bandwidth monitor

          # ==========================================
          # UTILITIES
          # ==========================================
          gitflow

          # ==========================================
          # GIGDOT PROGRAMS
          # ==========================================
          inputs.gigdot.packages.${system}.quick-results
          inputs.gigdot.packages.${system}.upignore
          inputs.gigdot.packages.${system}.cargo-update
        ];

        shellHook = ''
                    echo "🦀 Playarr Development Environment" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat 2> /dev/null;
                    
                    # Create project directories if they don't exist
                    mkdir -p .devshell/{db,scripts,samples}
                    
                    # Set up database path for development
                    export DATABASE_URL="sqlite://$PWD/.devshell/db/playarr-dev.db"
                    export RUST_LOG="playarr=debug,sqlx=info"
                    
                    # Helpful aliases for nushell
                    cat > .devshell/aliases.nu << 'EOF'
          # Database aliases
          alias db-shell = sqlite3 .devshell/db/playarr-dev.db
          alias db-browse = sqlitebrowser .devshell/db/playarr-dev.db
          alias db-clean = rm -f .devshell/db/playarr-dev.db
          alias db-migrate = sqlx migrate run --database-url $env.DATABASE_URL

          # API testing aliases (examples)
          def plex-test [endpoint: string] {
            http get $"($env.PLEX_URL)/($endpoint)?X-Plex-Token=($env.PLEX_TOKEN)"
          }

          def sonarr-test [endpoint: string] {
            http get $"($env.SONARR_URL)/api/v3/($endpoint)" -H [X-Api-Key $env.SONARR_API_KEY]
          }

          def tautulli-test [cmd: string] {
            http get $"($env.TAUTULLI_URL)?apikey=($env.TAUTULLI_API_KEY)&cmd=($cmd)"
          }

          # Docker aliases
          alias docker-build = nix build .#docker-image
          alias docker-load = docker load < result

          # Development workflow
          alias dev = cargo watch -x run
          alias check-all = cargo clippy --all-targets --all-features -- -D warnings
          EOF
                    
                    echo ""
                    echo "📦 Available tools:"
                    echo "  Database:  sqlite3, litecli, sqlitebrowser, dbeaver"
                    echo "  API Test:  httpie, xh, curl, bruno, hurl"
                    echo "  JSON:      jq, jless, fx, gron"
                    echo "  Docker:    docker, podman, dive, skopeo"
                    echo "  Rust:      cargo-watch, cargo-expand, bacon"
                    echo ""
                    echo "💡 Quick starts:"
                    echo "  • Initialize DB:     sqlx database create && sqlx migrate run"
                    echo "  • Browse DB (CLI):   litecli \$DATABASE_URL"
                    echo "  • Browse DB (GUI):   sqlitebrowser .devshell/db/playarr-dev.db"
                    echo "  • Test Sonarr API:   http GET \$SONARR_URL/api/v3/system/status X-Api-Key:\$SONARR_API_KEY"
                    echo "  • Test Plex API:     http GET \$PLEX_URL/ X-Plex-Token:\$PLEX_TOKEN"
                    echo "  • Auto-rebuild:      cargo watch -x run"
                    echo ""
                    echo "📝 Load nushell aliases: source .devshell/aliases.nu"
                    echo "📖 See docs/DEVELOPMENT_GUIDE.md for step-by-step instructions"
                    echo ""
        '';
      };
    };
}
