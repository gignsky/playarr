#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]
use clap::Parser; // ARGS Parser
use serde::Deserialize;
use std::fs;
use std::path::Path;

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

fn main() {
    let args = Args::parse();
    if args.verbose {
        println!("DEBUG {args:?}");
    }
    println!(
        "Hello {} (from playarr)!",
        args.name.unwrap_or("world".to_string())
    );

    /// Define path to config file
    let config_path = Path::new("config.toml");
    let config = read_config(Path::new(config_path));

    // Print the config for debugging
    println!("Config: {:#?}", config);
}

/// Reads config file into structs for general configuration reference
fn read_config(config_path: &Path) -> Config {
    let config_str = r#"
        [general]
        log_level = 1
        download_target = "full_season"
        episode_threshold = 4

        [plex]
        url = "http://ip_to_plex_server:32400/"
        token = "plex_token"
        tv_shows_library = "tv_show_library_name_from_plex"

        [sonarr]
        url = "http://ip_to_sonarr:8989"
        api_key = "api_key"
    "#;
    // fs::read_to_string(config_path).expect("Unable to read config file");
    let config: Config = toml::from_str(&config_str).expect("Unable to parse config file");
    config
}

#[derive(Deserialize, Debug)]
struct Config {
    general: GeneralConfig,
    plex: Plex,
    sonarr: Sonarr,
}

#[derive(Deserialize, Debug)]
struct GeneralConfig {
    log_level: u8,
    download_target: String,
    episode_threshold: u8,
}

#[derive(Deserialize, Debug)]
struct Plex {
    url: String,
    token: String,
    tv_shows_library: String,
}

#[derive(Deserialize, Debug)]
struct Sonarr {
    url: String,
    api_key: String,
}
