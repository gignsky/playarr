/// Parse the config file and return a struct with the configuration with an error if the file is not found
use serde::Deserialize;
use std::fs;
use std::path::Path;

/// Reads config file into structs for general configuration reference
pub fn read_config(config_path: &Path) -> Config {
    // Example config string for testing
    // let config_str = r#"
    //     [general]
    //     log_level = 1
    //     download_target = "full_season"
    //     episode_threshold = 4

    //     [plex]
    //     url = "http://ip_to_plex_server:32400/"
    //     token = "plex_token"
    //     tv_shows_library = "tv_show_library_name_from_plex"

    //     [sonarr]
    //     url = "http://ip_to_sonarr:8989"
    //     api_key = "api_key"
    // "#;

    let config_str = fs::read_to_string(config_path).expect("Unable to read config file");
    let config: Config = toml::from_str(&config_str).expect("Unable to parse config file");
    // let config = match config {
    //     Ok(config) => config,
    //     Err(error) => panic!("Error parsing config file: {}", error),
    // };
    config
}

#[derive(Deserialize, Debug)]
pub struct Config {
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
