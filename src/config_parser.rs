//! Deserilize the config file into rust structs
//!
//! This module contains all the structs and functions to parse the config file so that initialization of the program can begin
//! this module will check that all nececcary components are present in the config file

/// Parse the config file and return a struct with the configuration with an error if the file is not found
use serde::Deserialize;
use std::fs;
use std::io;
use std::path::Path;
use url::{ParseError, Url};

/// Reads config file into structs for general configuration reference
///
/// # Example Config File
///
/// ```toml
/// [general]
/// log_level = 1
/// download_target = "full_season"
/// episode_threshold = 4
///
/// [plex]
/// url = "http://ip_to_plex_server:32400/"
/// token = "plex_token"
/// tv_shows_library = "tv_show_library_name_from_plex"
///
/// [sonarr]
/// url = "http://ip_to_sonarr:8989"
/// api_key = "api_key"
/// ```
///
pub fn read_config(config_path: &Path) -> Result<Config, io::Error> {
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

    let config_str = fs::read_to_string(config_path).expect("ERROR: Unable to read config file");
    let config: Result<Config, toml::de::Error> = toml::from_str(&config_str); //.expect("ERROR: Unable to parse config file");
    match config {
        Ok(config) => {
            // println!("Config: {:#?}", config);
            Ok(config)
        }
        Err(e) => {
            eprintln!("ERROR: Unable to parse config file: {}", e);
            Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Failed to parse config",
            ))
        }
    }
}

#[derive(Deserialize, Debug)]
pub struct Config {
    pub general: GeneralConfig,
    pub plex: Plex,
    pub sonarr: Sonarr,
}

#[derive(Deserialize, Debug)]
pub struct GeneralConfig {
    pub log_level: u8,
    pub download_target: String,
    pub episode_threshold: u8,
}

#[derive(Deserialize, Debug)]
pub struct Plex {
    pub url: Url,
    pub token: String,
    pub tv_shows_library: String,
}

#[derive(Deserialize, Debug)]
pub struct Sonarr {
    pub url: Url,
    pub api_key: String,
}
