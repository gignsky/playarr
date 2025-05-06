// ARGS Parser
use clap::Parser;
use serde::Deserialize;
use std::fs;
use std::path::Path;

mod plex;
mod sonarr;

#[derive(Parser, Debug)]
#[clap(author = "Maxwell Rupp", version, about)]
/// Application configuration
struct Args {
    /// whether to be verbose
    #[arg(short = 'v', long = "verbose")]
    verbose: bool,

    /// an optional name to greet
    #[arg()]
    name: Option<String>,
}

// Non-TUI Stuff
fn main() {
    let args = Args::parse();
    if args.verbose {
        println!("DEBUG {args:?}");
    }
    println!(
        "Hello {} (from playarr)!",
        args.name.unwrap_or("world".to_string())
    );

    let config_path = Path::new("config.toml");
}

fn read_config(config_path: &Path) -> Config {
    let config_str = fs::read_to_string(config_path).expect("Unable to read config file");
    let config: Config = toml::from_str(&config_str).expect("Unable to parse config file");
    config
}

struct Config {
    general: GeneralConfig,
    sonarr: sonarr::Sonarr,
    plex: plex::Plex,
}

#[derive(Deserialize)]
struct GeneralConfig {
    log_level: u8,
    episode_thereshold: u8,
}
